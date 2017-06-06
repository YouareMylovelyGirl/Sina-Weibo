//
//  VisitorView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/6.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

/// 访客视图
class VisitorView: UIView {
    //构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 私有控件
    ///图像视图
    fileprivate lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_smallicon"))
    
    //模糊图片
    fileprivate var maskIconView: UIImageView = UIImageView(image: UIImage.init(named: "visitordiscover_feed_mask_smallicon"))
    
    ///小房子
    fileprivate lazy var houseIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_house"))
    ///提示标签
    fileprivate lazy var tipLabel = { () -> UILabel in
        let label = UILabel.init()
        label.text = "关注一些人, 回这里看看有什么惊喜关注一些人, 回这里看看有什么惊喜"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        return label
    }()
    ///注册按钮
    fileprivate lazy var registerButton = { () -> UIButton in
        let button = UIButton.init(type: .system)
        button.setTitle("注册", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.setBackgroundImage(UIImage.init(named: "common_button_white_disable"), for: .normal)
        button.sizeToFit()
        
        return button
    }()
    ///登录按钮
    fileprivate lazy var loginButton = { () -> UIButton in
        let button = UIButton.init(type: .system)
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.setBackgroundImage(UIImage.init(named: "common_button_white_disable"), for: .normal)
        button.sizeToFit()
        
        return button
    }()
}

// MARK: - 设置界面
extension VisitorView {
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        
        //1. 添加控件
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        //2. 使用原生自动布局 需要 取消autoresizing
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //3. 自动布局
        let margin: CGFloat = 20
        
        //1> 图像视图
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: -90))
        
        //2> 小房子
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: houseIconView,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerY,
                                         multiplier: 1.0,
                                         constant: 0))
        
        //3> 提示标签
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: iconView,
                                         attribute: .centerX, 
                                         multiplier: 1.0,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .top, relatedBy: .equal, toItem: iconView,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        addConstraint(NSLayoutConstraint(item: tipLabel,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: UIScreen.main.bounds.size.width - 150))
        
        //4> 注册按钮
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        
        addConstraint(NSLayoutConstraint(item: registerButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        //5> 登录按钮
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .right,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .right,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .top,
                                         relatedBy: .equal,
                                         toItem: tipLabel,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: margin))
        
        addConstraint(NSLayoutConstraint(item: loginButton,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil, attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 100))
        
        //6> 遮罩图像 
        //views: 定义VFL中的控件名称和实际名称映射关系
        //metrice: 定义VFL中() 指定的常熟映射关系
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : Any]
        let metrice = ["spacing": -35]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[maskIconView]-0-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[maskIconView]-(spacing)-[registerButton]",
                                                      options: [],
                                                      metrics: metrice,
                                                      views: viewDict))
        
    }
}







