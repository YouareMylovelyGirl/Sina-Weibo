//
//  HomeController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

//定义全局常量, 尽量使用private修饰, 要不然导出都能使用

/// 原创微博cellid
fileprivate let originalCellId = "originalCellId"
/// 被转发微博的可重用cellid
fileprivate let retweetedCellId = "retweetedCellId"

class HomeController: BaseViewController {
    
    //列表视图模型
    fileprivate lazy var listViewModel = StatusListViewModel()
    
    
    
    /// 显示好友
    @objc fileprivate func showFriends() {
        print(#function);
        let vc = DemoViewController()
        //控制器push时隐藏下面的条, 弊端就是容易忘记
//        vc.hidesBottomBarWhenPushed = true
        //push 的动作是nav做的
        navigationController?.pushViewController(vc, animated: true)
    }

    //加载数据
    override func loadData() {
        
        refreshControl?.beginRefreshing()
        
//        print("准备刷新, 最后一条\(String(describing: self.listViewModel.statusList.first?.text))")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.listViewModel.loadStatus(pullUp: self.isPullup) { (data, error, shouldRefredh) in
                print("加载数据结束")
                //结束刷新控件
                self.refreshControl?.endRefreshing()
                //恢复上拉刷新标记
                self.isPullup = false
                
                //刷新表格, 如果能够上啦刷新再去刷新
                if shouldRefredh {
                    self.tableView?.reloadData()
                }
            }
        }
        
        
    }
}

// MARK: - 表格数据源方法, 具体的数据源方法实现,不需要super
extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ///FIXME: - 修改Id
        //0. 取出视图模型, 根据视图模型判断可重用cell
        let vm = listViewModel.statusList[indexPath.row]
        
        let cellId = (vm.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        
        //1. 取cell - 本身会调用代理方法(如果有), 如果没有, 找到cell, 按照自动布局规则, 从上向下计算, 找到向下的约束, 从而计算动态行高
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! StatusCell
        //2. 设置cell
        let viewModel = listViewModel.statusList[indexPath.row]
        
        cell.viewModel = viewModel
        
        
        
        //3. 返回cell
        return cell
    }
    
    //设置行高
    //没有override, 在2.0 没有关系, 在3.0没有overide父类没有提供这个方法 Swift3.1 进行完善
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //1. 根据indexPath获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        
        //2. 返回计算好的行高
        return vm.rowHeight
    }
    
}


// MARK: - 设置界面
extension HomeController {
    
    /*
     父类写了一个方法, 子类去重写这个方法, 这样就能做到每一个控制器定制化
     */
    
    override func setupTableView() {
        super.setupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", fontSize: 16, target: self, action: #selector(showFriends))

        //这里需要先注册原形cell
//        tableView?.register(UITableViewCell.self, fosrCellReuseIdentifier: cellID)
        
        //注册原型cell
        tableView?.register(UINib(nibName: "StatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
        setupNavTitle()
        
        tableView?.register(UINib(nibName: "StatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
        setupNavTitle()
        
        // 设置行高
//        tableView?.rowHeight = UITableViewAutomaticDimension
//        tableView?.estimatedRowHeight = 300
        
        // 取消分割线
        tableView?.separatorStyle = .none
    
    }
    
    //设置导航栏标题
    fileprivate func setupNavTitle() {
        
        let title = NetManager.shareInstance.userAccount.screen_name
        //指定构造函数一定有值
        let button = TitleButton(title: title)
        //点击按钮的事件方法
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        navItem.titleView = button
    }
    
    @objc fileprivate func clickTitleButton(btn: UIButton) {
        //设置选中状态
        btn.isSelected = !btn.isSelected
    }
    
    
    //重写父类方法
//    override func setupUI() {
//        super.setupUI()
//        //设置导航栏按钮
//        //Swift调用OC返回instancetype的方法,判断不出是否可选
//        //便利构造函数
//        
//        //Swift中的便利构造函数就相当关于OC中的重写构造函数 init
//        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", fontSize: 16, target: self, action: #selector(showFriends))
//        
//        //这里需要先注册原形cell
//        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
//        
//    }
}
