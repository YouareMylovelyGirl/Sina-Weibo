//
//  MainViewController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
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
        
 
    }
    
    deinit {
        //销毁时钟
        timer?.invalidate()
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
    //定义时钟
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    ///中出发方法
    @objc fileprivate func updateTimer() {
        //测试未读数量
        NetManager.shareInstance.unreadCount { (count) in
            
            print("检测到\(count)条")
            
            //设置 首页的 tabBarItem 的 badgeNumber
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
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
        // 向内缩进的宽度减少, 能够让按钮的宽度变大, 盖住容错点
        let width = tabBar.bounds.width / count - 1
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








