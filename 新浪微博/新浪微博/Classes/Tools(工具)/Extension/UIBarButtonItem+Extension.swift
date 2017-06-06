//
//  UIBarButtonItem+Extension.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
import UIKit
extension UIBarButtonItem {
    
    
    /// 创建UIBarBarItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize 默认16
    ///   - target: target
    ///   - action: action
    ///   - isBack: 是否返回按钮, 如果是加上箭头
    
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector, isBack: Bool = false) {
        let btn = UIButton.init(type: .custom)
        //        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize )
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        
        if isBack {
            let imageNormal = "btn_nav_back"
            let imageLight = "btn_nav_back_click"
            btn.setImage(UIImage.init(named: imageNormal), for: .normal)
            btn.setImage(UIImage.init(named: imageLight), for: .highlighted)
        }
        
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        
        
        
        //self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}
