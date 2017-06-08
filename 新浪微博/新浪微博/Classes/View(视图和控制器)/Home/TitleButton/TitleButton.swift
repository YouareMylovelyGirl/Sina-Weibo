//
//  TitleButton.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/8.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    //重载构造函数
    //如果title是nil, 就显示首页
    //如果不为niu, 就显示title 和 箭头头像
    init(title: String?) {
        super.init(frame: CGRect())
        
        //1. 判断title是否为nil
        if title == nil {
            setTitle("首页", for: .normal)
        } else {
            //加一个空格往往能够决定一个距离
            setTitle(title!+" ", for: .normal)
            
            setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        //2. 设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)

        
        sizeToFit()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //重新调整文字和图像的位置是纯代码布局最常用的方式
    
    //重新布局自视图
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let titleLabel = titleLabel,
        let imageView = imageView else {
            return
        }

        
        print("调整按钮布局")
        
        //将label的x向左移动 imageView的宽度
//        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.size.width, dy: 0)
////        //将imageView的想 想右移动label的宽度
//        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.size.width, dy: 0)
        
        // 将 label 的 x 向左移动 imageView 的宽度
        // OC 中不允许直接修改`结构体内部的值`
        // Swift 中可以直接修改
        titleLabel.frame.origin.x = 0
        
        // 将 imageView 的 x 向右移动 label 的宽度
        imageView.frame.origin.x = titleLabel.bounds.width
        
        
        
    }

}
