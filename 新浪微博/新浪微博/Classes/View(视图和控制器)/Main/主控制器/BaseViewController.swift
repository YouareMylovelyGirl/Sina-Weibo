//
//  BaseViewController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
//swift 中协议和数据源方法直接用, 接在后面
// 面试题: OC中支持多继承吗? 如果不支持如何实现, 如何替代? 答案: 使用协议替代
//class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

//Swift中利用extension 可以把函数按照功能分类管理, 便于阅读和维护
/*
 注意:
 1. extension: 中不能有属性
 2. extension: 中不能重写父类方法! 重写父类方法, 狮子类的职责, 扩展是对类的扩展
        如果父类方法写在extension中, 子类方法如果重写也要在extension中重写
 */


//所有自控制器的基类控制器
class BaseViewController: UIViewController {
    
    //用户登录标记 来决定显示的视图
//    var userLogon = true
    
    //访客视图信息字典
    var visitInfoDic: [String: String]?
    
    //上拉刷新标记
    var isPullup = false
    
    //刷新控件
    var refreshControl: UIRefreshControl?
    
    /// 表格视图 - 如果用户没有登录, 就不创建
    var tableView: UITableView?
    //自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 64))
   
    //自定义导航条目 - 以后设置导航栏内容 统一使用navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NetManager.shareInstance.userLogon ? loadData() : ()
        //注册登录成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: UserLoginSuccessNotification), object: nil)
    }
    
    deinit {
        //注册完了通知以后第一件事情就是在这里销毁通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //didSet: 重写set方法
    override var title: String? {
        didSet {
            navItem.title = title
        }
    }
    
    //加载数据 - 具体的实现由子类负责
    func loadData() {
        //如果子类不实现任何方法 关闭刷新, 防止别的控制器刷新不停止, 
        refreshControl?.endRefreshing()
    }
    
}

// MARK: - 设置界面
extension BaseViewController {
    
    fileprivate func setupUI() {
        
        //取消自动缩进 - 如果隐藏了曹行栏, 会自动缩进20个点
        automaticallyAdjustsScrollViewInsets = false;

        setupTableView()
        
        //随机颜色
        view.backgroundColor = UIColor.white
        
        //加载导航控制器
        setupNavigationBar()
        
        //三目运算判断应该加载哪一个视图
//        userLogon ? setupTableView() : setupVisitorView()
        NetManager.shareInstance.userLogon ? setupTableView() : setupVisitorView()
        
    }
    
    //设置导航条   抽取消防法
    private func setupNavigationBar() {
        //添加导航条
        view.addSubview(navigationBar)
        
        //将Item设置给bar
        navigationBar.items = [navItem]
        
        //这只navBar的渲染颜色 设置整个背景的颜色
        //        navigationBar.barTintColor = UIColor.init(white: 0.9, alpha: 1.0)
        //或者设置到航条不透明
        navigationBar.isTranslucent = false
        //设置NavBar的字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        //设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
    }
    
    //设置表格视图  - 用户登陆之后执行 (子类重写此方法)
    //因为子类不需要关心用户登录之前的逻辑
    func setupTableView() {
        
        //如果没有登录tableView中的视图就不用先加载了
        if !(NetManager.shareInstance.userLogon) {
            return
        } else {
            
            //导航条没有压到状态栏, 相当于空了20个像素  如果设置了 autoxxxinsert = false, 则需要加上那20
            //        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 64, width: view.bounds.size.width, height: view.bounds.size.height), style: .plain)
            
            tableView = UITableView.init(frame: view.frame, style: .plain)
            
            //这么添加还需要考虑控件加载的先后顺序
            //        view.addSubview(tableView!)
            view.insertSubview(tableView!, belowSubview: navigationBar)
            
            // 设置数据源&代理 -> 目的:子类直接实现数据源方法
            tableView?.delegate = self
            tableView?.dataSource = self
            
            //设置内容缩进  tabbar 的默认高度是49
            tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
            
            //修改指示器的缩进 (上下滑动条)  - 强行解包是为了拿到必有的inset
            tableView?.scrollIndicatorInsets = tableView!.contentInset
            
            //设置刷新控件
            //1. 实例化控件
            refreshControl = UIRefreshControl()
            //2. 添加到表格视图
            tableView?.addSubview(refreshControl!)
            //3. 添加监听方法
            refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
            
        }
    }
    
    
    //设置访客视图
    private func setupVisitorView() {
        let visitorView = VisitorView(frame: view.bounds)
        
        //使用这个不好, 因为导航条会被挡住, 应该使用插入
        //view.addSubview(visitorView)
        
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        //1. 设置访客视图信息
        visitorView.visitorInfo = visitInfoDic
        
        //2. 添加访客视图按钮的监听方法
        visitorView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        visitorView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        //3. 设置导航条按钮 左右两端按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(register))
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(login))
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension BaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    //基类只是准备方法, 子类负责具体的实现
    //子类的数据源不需要遵守
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //只是保证没有语法错误
        return UITableViewCell ()
    }
    
    //在显示最后一行的时候, 做上拉刷新
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //1. 判断 indexPath 是否最后一行
        // indexpath.setcion(最大) / indexPath.row(最后一行)
        let row = indexPath.row
        //2. section
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        //3. 哪一组有多少 行数
        let count = tableView.numberOfRows(inSection: section)
        
        //如果是最后一行, 同时没有开始上拉刷新
        if row == (count - 1) && !isPullup {
            print("上拉刷新")
            isPullup = true
            
            //开始刷新
            loadData()
        }
        
//        print("section --- \(section)")
    }
}

// MARK: - 访客视图监听方法
extension BaseViewController {
    @objc fileprivate func login() {
        print("用户登录")
        //发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:UserShouldLoginNotification), object: nil)
    }
    
    @objc fileprivate func register() {
        print("用户注册")
    }
    
    //登录成功发出通知
    @objc fileprivate func loginSuccess(n: Notification) {
//        print("登录成功\(n)")
        
        //登录前左边是注册, 右边是登录
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        
        //更新UI => 将访客视图替换为表格视图
        // 需要重新执行设置View
        //在访问view的getter时, 如果view == nil 会调用 loadView -> viewDidLoad
        view = nil
        
        //注销通知 -> 重新执行, viewDidLoad会再次注册! 避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
        
    }
}
