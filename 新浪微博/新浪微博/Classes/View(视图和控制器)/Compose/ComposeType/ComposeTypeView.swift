//
//  ComposeTypeView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/13.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class ComposeTypeView: UIView {

    class func composeTypeView() -> ComposeTypeView {
        let nib = UINib(nibName: "ComposeTypeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ComposeTypeView
        
        //xib 默认是600 x 600
        v.frame = UIScreen.main.bounds
        
        return v
        
    }

    
    /// 显示当前视图
    func show() {
        //1. 将当前视图添加到
        //拿到跟视图控制器 加到跟视图控制器的View
        guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        //2. 添加视图
        vc.view.addSubview(self)
    }
    
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //MARK: - 监听方法
    @objc fileprivate func clickButton() {
        print("点我了")
    }
    
}

//里面每个函数都是私有
fileprivate extension ComposeTypeView {
    func setupUI() {
        //1. 创建类型按钮
        let btn = ComposeTypeButton.composeTypeButton(imageName: "tabbar_compose_idea", title: "试一试")
        btn.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        //2. 添加监听方法
        btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        addSubview(btn)
    }
}
