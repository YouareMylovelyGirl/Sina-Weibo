//
//  MainNavigationController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏默认的NavigationBar
        navigationBar.isHidden = true
        
    }

    //重写push方法隐藏底部的tabBar
    //viewController: 是被push的控制器, 设置他的左侧的按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //如果 不是栈底控制器不需要隐藏, 跟控制器不需要隐藏
        if childViewControllers.count > 0 {
            
            //重写push, 所有的push方法都会调用此方法!
            //隐藏底部的TabBar
            viewController.hidesBottomBarWhenPushed = true
            
            //判断控制器类型
            //if let 这里一定要用 as?
            if let vc = viewController as? BaseViewController {
                var title = "返回"
                //判断控制器级数
                if childViewControllers.count == 1 {
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                //取出自定义的item
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, fontSize: 16, target: self, action: #selector(popLastVC), isBack: true)
            }
        }

        super.pushViewController(viewController, animated: true)

    }
    
    @objc fileprivate func popLastVC() {
        popViewController(animated: true)
    }
}
