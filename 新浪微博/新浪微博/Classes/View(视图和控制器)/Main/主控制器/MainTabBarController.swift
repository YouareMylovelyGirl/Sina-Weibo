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

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置所有自控制器
        setupChildViewControllers()
        
        //设置中间按钮
        setupComposeButton()
 
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
        let array = [
            ["className": "HomeController", "title": "首页", "imageName": "home"],
            ["className": "DiscoverController", "title": "发现", "imageName": "discover"],
            //中间按钮的占位
            ["className": " UIViewController"],
            ["className": "MessageController", "title": "消息", "imageName": "message_center"],
            ["className": "ProfileController", "title": "我", "imageName": "profile"],
            
        ]
        //这个数组中装的都是控制器
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个自控制器
    ///
    /// - Parameter dict: 信息字典
    /// - Returns: 自控制器
    private func controller(dict: [String: String]) -> UIViewController {
        //1. 取得字典内容
        guard let className = dict["className"],
        let title = dict["title"],
        let imageName = dict["imageName"],
        let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type
        else {
            return  UIViewController()
        }
        //2. 创建视图控制器
        let vc = cls.init()
        //3. 设置标题
        vc.title = title
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








