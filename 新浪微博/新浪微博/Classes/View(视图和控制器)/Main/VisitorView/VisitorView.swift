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
    
    ///注册按钮
        lazy var registerButton = { () -> UIButton in
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
        lazy var loginButton = { () -> UIButton in
        let button = UIButton.init(type: .system)
        button.setTitle("登录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.setBackgroundImage(UIImage.init(named: "common_button_white_disable"), for: .normal)
        button.sizeToFit()
        
        return button
    }()

    
    
    //访客视图的信息字典 [imageName/ message]
    //如果是首页 imageName = ""
    var visitorInfo: [String: String]? {
        didSet {
            //1> 获取字典信息
            //这个时候visitorInfo就已经有值了
            guard let imageName = visitorInfo?["imageName"],
                let message = visitorInfo?["message"] else {
                    return
            }
            //2> 设置消息
            tipLabel.text = message
            
            //3> 设置图像, 首页不需要设置
            if imageName == "" {
                startAnimation()
                return
            }
            
            iconView.image = UIImage(named: imageName)
            
            //其他控制器的访客视图不需要显示小房子
            houseIconView.isHidden = true
            //遮罩视图也不需要了
            maskIconView.isHidden = true
        }
    }
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - 私有方法
    ///设置旋转动画
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 15
        
        //完成之后不删除, 如果iconView被释放, 动画会一起销毁!
        //在设置连续动画时非常有用
        anim.isRemovedOnCompletion = false
        
        //将动画添加到图层
        iconView.layer.add(anim, forKey: nil)
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
}

// MARK: - 设置界面
extension VisitorView {
    
    fileprivate func setupUI() {
        //0XEDEDED 背景颜色
        //以后能够使用颜色就不要使用图片
        backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        
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
                                         constant: -30))
        
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
        
        //6> 遮罩图像 VFL
        //views: 定义VFL中的控件名称和实际名称映射关系
        //metrice: 定义VFL中() 指定的常熟映射关系
        let viewDict = ["maskIconView": maskIconView,
                        "registerButton": registerButton] as [String : Any]
        let metrice = ["spacing": -50]
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








