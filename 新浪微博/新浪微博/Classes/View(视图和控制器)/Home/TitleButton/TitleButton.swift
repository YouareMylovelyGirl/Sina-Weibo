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
            setTitle(title!, for: .normal)
            
            setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        //2. 设置字体和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        setTitleColor(UIColor.black, for: .selected)
        
        sizeToFit()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
