//
//  ComposeTypeButton.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/13.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

//
class ComposeTypeButton: UIControl {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    ///点击按钮要展现控制器的类型
    var clsName: String?
    
    
    /// 使用图像名称/ 标题创建按钮, 按钮布局从xib中加载
    /*
     如果遇到了, 点击图片不能够哦交互, 点击文字或者其他地方都可以交互, 并且继承UIControl, 此时就要将这两个 与用户交互关闭, 因为UIControl内置了 touchupinside
     */
    class func composeTypeButton(imageName: String, title: String) -> ComposeTypeButton {
        let nib = UINib(nibName: "ComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! ComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
        
    }
    
}
