//
//  MainViewController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
import SVProgressHUD
//主控制器
class MainTabBarController: UITabBarController {

    //定时器
    fileprivate var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置所有自控制器
        setupChildViewControllers()
        
        //设置中间按钮
        setupComposeButton()
        

        //定义时钟
        setupTimer()
        
        //设置新特性视图
        setupNewfeatureViews()
        
        //设置代理   将自己设置为自己的代理
        delegate = self as UITabBarControllerDelegate
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: nil)
        
 
    }
    
    deinit {
        //销毁时钟
        timer?.invalidate()
        
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
     支持的设备方向
     portrait: 竖屏   肖像
     landscape: 横屏  风景
     
     - 使用代码控制器设备的方向, 好处可以在需要横屏的时候, 单独处理
     - 设置支持的方向之后, 当前的控制器及自控制器都会遵守这个方向
     - 如果播放视频, 通常是通过modal展现的
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    

    //MARK: - 监听方法
    
    @objc fileprivate func userLogin(n: Notification) {
        print("用户通知\(n)")
        
        var when = DispatchTime.now()
        
        //判断n 的 object 如果有值,提示用户重新登录 
        if n.object != nil {
            
            //设置指示器的简便样式
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.showInfo(withStatus: "用户登录已超时, 需要重新登录")
            
            // 修改延时
            when = DispatchTime.now() + 1
        }
        
        //利用GCD延迟加载以下代码
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let nav = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(nav, animated: true, completion: nil)
        }
        
        
    }
    
    
    //FIXME: 没有实现
    //private: 能够保证方法私有, 仅在当前对象被访问
    //@objc 允许这个函数在运行时通过 OC 的消息被调用 
    @objc fileprivate func composeStatus() {
        print("写微博")
        // 测试方向旋转
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.view.backgroundColor = UIColor.init().randomColor
        
        present(nav, animated: true, completion: nil)
        
    }
    
    // MARK: - 私有控件
    //懒加载需要再后面加上()
    fileprivate lazy var composeButton = { () -> UIButton in
        
        var button = UIButton.init(type: .custom)
        button.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: .normal)
        button.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        button.setImage(UIImage.init(named: "tabbar_compose_icon_add"), for: .normal)
        button.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)

        return button
    }()

}


extension MainTabBarController {
    /*
     关于版本号
     在appstore每次升级应用程序, 版本号都需要增加   不能递减
     组成 主版本号, 次版本号
     主版本号变化: 意味着大的修改
     次版本号: 小的修改, 某些函数参数, 和方法的使用或者参数有变化
     修订版本号: 框架/ 程序内部bug的修订, 不会对使用者造成任何影响
     */
    fileprivate func setupNewfeatureViews() {
        
        //0. 判断是否登录
        if !NetManager.shareInstance.userLogon {
            
        }
        
        //1. 检查版本是否更新
        
        //2. 如果更新, 显示新特性, 否则显示欢迎
        let v = isNewVersion ? NewFeatureView.newFeature() : WelcomeView.welcome()
        //3. 添加视图, 在view中s 
//        v.frame = view.bounds
        
        view.addSubview(v)
    }
    
    //extension中可以有 计算型方法  不会占用存储空间
    //够赞函数: 给属性分配存储空间
    private var isNewVersion: Bool {
        //1. 取当前的版本号
        //可选的字典需要在后面主动加上?
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        print("当前版本" + currentVersion)
        //2. 取保存在`Document(iTunes)`应用程序升级, 这个文件也会被保存. [应该保存在偏好设置中]
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)
        let documnetPath = documentPaths[0] as NSString
        let filePath = documnetPath.appendingPathComponent("version")
        
        let sandboxVersion = (try? String(contentsOfFile: filePath)) ?? ""
         
        print("沙盒版本" + sandboxVersion)
        print(filePath)
        //3. 将当前版本保存在沙盒
       _ = try? currentVersion.write(toFile: filePath, atomically: true, encoding: .utf8)
        //4. 返回两个版本号 `是否一致`
        
        return currentVersion != sandboxVersion
//        return true
    }
}


// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    
    /// 将要选择 TabBarItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: 目标控制器
    /// - Returns: 是否切换到目标控制器
    
    //////:::这里尤其注意只有再点击了 首页的时候
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("将要切换到 \(viewController)")
        
        
        
        
        
        //找死了这个bug.........
        //FIXME: 这里如果一开始不是展示内容的话点击 item时候会出现bug , 直接弹出控制器, 所以这里要先进行一下判断是否已经登陆了, 如果没有登录, 也就没有必要进行刷新了, 如果这里需要展示内容, 那就把这个用户是否登录的判断删除
        if NetManager.shareInstance.userLogon {
            //1> 获取控制器在数组中的索引, 这个是应用了NSarray的 indexof 方法, 获取控制器所在的索引值
            let index = (childViewControllers as NSArray).index(of: viewController)
            //2> 判断当前索引是首页, 同时 index 也是首页, 重复点击首页的按钮
            if selectedIndex == 0 && index == selectedIndex {
                print("点击首页")
                //3> 让表格滚动到顶部
                //a) 获取到控制器 一开始获取到的是导航控制器, 需要获取跟控制器就得从导航控制器中重新获取
                let nav = childViewControllers[0] as! UINavigationController
                //从导航控制器中获取跟控制器
                let vc = nav.childViewControllers[0] as! HomeController
                //这是偏移, 滚动到顶部
                vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
                
                //4> 刷新表格 如果直接调用loadData 就会出现胡乱加载的问题
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    vc.loadData()
                    
                }
                
                //5> 清除tabbaritem的badgeNumber
                vc.tabBarItem.badgeValue = nil
                UIApplication.shared.applicationIconBadgeNumber = 0
            }

        }
        
        
        
        //判断目标控制器是否是UIViewController, 如果是的话就不允许点击
        return !viewController.isMember(of: UIViewController.self)
    }
}

extension MainTabBarController {
    //定义时钟
    fileprivate func setupTimer() {
        //时间间隔建议长一些 60s
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    ///中出发方法
    @objc fileprivate func updateTimer() {
        
        if !NetManager.shareInstance.userLogon {
            return
        }
        
        //测试未读数量
        NetManager.shareInstance.unreadCount { (count) in
            
            print("检测到\(count)条")
            
            //设置 首页的 tabBarItem 的 badgeNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            //设置 APP的badgeNumber, 从iOS8.0之后, 要用户授权之后才能够显示
            UIApplication.shared.applicationIconBadgeNumber = count
            
        }
    }
}


// extension 类似于OC中的分类, 在Swift中还可以用来切分代码块
//可以把相近空能的函数, 放在一个extension钟
//注意: 和 OC中一样, extension 中不能定义属性


// MARK: - 设置界面
extension MainTabBarController {
    
    //设置中间按钮
    fileprivate func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        //计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        // 向内缩进的宽度
        let width = tabBar.bounds.width / count
        //CGRectInset 正数向内缩进, 辅助向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * width, dy: 0)
        
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
    }
    
    
    //设置所有子控制器
    fileprivate func setupChildViewControllers() {
        
        //0. 获取沙盒路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let jsonPath = (docDir as NSString).appendingPathComponent("Main.json")

        //加载data
        var data = NSData(contentsOfFile: jsonPath)
        
        //判断data是否有内容, 如果没有, 说明本地沙河没有文件
        if data == nil {
            //从bundle中加载date
            let path = Bundle.main.path(forResource: "Main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
            
        }
        
        
        //现在很多应用程序中, 界面的创建都依赖网络的json
        //从bundle加载配置json
        //反序列化加载数组
            //JSON 到Data 反序列化
            guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]] else {
            return
        }
        
        
/*
        let array1 = [
            ["className": "HomeController", "title": "首页", "imageName": "home", "visitorInfo": ["imageName": "", "message" :"关注一些人,回这里看看有什么惊喜"]],
            ["className": "DiscoverController", "title": "发现", "imageName": "discover", "visitorInfo": ["imageName": "visitordiscover_image_message", "message" :"登陆后, 别人评论你的微博, 发给你的消息, 都会在这里收到通知"]],

            //中间按钮的占位
            ["className": " UIViewController"],
            ["className": "MessageController", "title": "消息", "imageName": "message_center", "visitorInfo": ["imageName": "visitordiscover_image_message", "message" :"登录后, 最新, 最热微博仅在掌握, 不再与时事潮流擦肩而过"]],

            ["className": "ProfileController", "title": "我", "imageName": "profile", "visitorInfo": ["imageName": "visitordiscover_image_profile", "message" :"登陆后,你的微博,相册,个人资料会显示在这里,展示给别人"]],

        ]
        
        //如果想要写入沙盒, 需要用array转成NSarray, 转换成plist数据更加直观
//        (array as NSArray).write(toFile: <#T##String#>, atomically: <#T##Bool#>)
        
        //数组 -> json 序列化
        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
        (data as NSData).write(toFile: "/Users/koreyoshi/Desktop/Main.jason", atomically: true)
*/
        //这个数组中装的都是控制器
        var arrayM = [UIViewController]()
        for dict in array! {
            //string , array, dictionary 加as不需要! ? 桥接
            arrayM.append(controller(dict: dict as [String : AnyObject]))
        }
        
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个自控制器
    ///
    /// - Parameter dict: 信息字典
    /// - Returns: 自控制器
    private func controller(dict: [String: AnyObject]) -> UIViewController {
        //1. 取得字典内容
        guard let className = dict["className"] as? String,
        let title = dict["title"] as? String,
        let imageName = dict["imageName"] as? String,
        let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? BaseViewController.Type,
        let visitorDict = dict["visitorInfo"] as? [String: String]
        else {
            return  UIViewController()
        }
        //2. 创建视图控制器
        let vc = cls.init()
        //3. 设置标题
        vc.title = title
        
        //设置控制器的访客信息字典
        vc.visitInfoDic = visitorDict
        
        //4. 设置图片并且设置模式
        vc.tabBarItem.image = UIImage(named: "tabbar_"+imageName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_"+imageName+"_highlighted")?.withRenderingMode(.alwaysOriginal)
        
        //5. 设置tabBar标题字体
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        //设置字体大小  系统默认是12号字, 修改字体大小要设置normal, 设置高亮是没有作用的
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: .normal)
        
        // 实例化导航控制器的时候, 会调用push方法将rootVC压栈
        let nav = MainNavigationController(rootViewController: vc)
        
        return nav
        

        
    }
    
    
}








