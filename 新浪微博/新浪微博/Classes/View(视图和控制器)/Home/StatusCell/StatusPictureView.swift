//
//  StatusPictureView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class StatusPictureView: UIView {
    
    //配图视图数组
    var urls: [StatusPicture]? {
        didSet {
            //隐藏所有的imageView
            for v in subviews {
                v.isHidden = true
            }
            
            //2. 便利urls数组, 顺序设置图像
            var index = 0
            
            let array = urls
            
            for u in array ?? [] {
                // 获得对应索引的ImageView
                let iv = subviews[index] as! UIImageView
                
                //设置 contentMode
                iv.contentMode = .scaleAspectFill
                iv.clipsToBounds = true
                
                //4张图像处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                //设置图像
                iv.yg_setImage(urlString: u.thumbnail_pic, placeholderImage: nil, isAvatar: false)
                //显示图像
                iv.isHidden = false
                index += 1
            }
            
    
        }
    }

    @IBOutlet weak var heightCons: NSLayoutConstraint!

    
    override func awakeFromNib() {
        setupUI()
    }
    
}

extension StatusPictureView {
    //1. cell中 所有的控件都是提前准备好
    //2. 设置的时候, 根据数据决定是否显示
    //3. 不要动态创建控件
    fileprivate func setupUI() {
        //这样设置就不用管俯视图是什么颜色了
        backgroundColor = superview?.backgroundColor
        
        //超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        
        let rect = CGRect(x: 0, y: StatusPictureViewOutterMargin, width: StatusPictureItemWidth, height: StatusPictureItemWidth)
        
        for i in 0..<count * count {
            let iv = UIImageView()
            iv.backgroundColor = UIColor.red
            //行 -> y
            let row = CGFloat (i / count)
            //列 -> x
            let col = CGFloat (i % count)
            
            
            iv.frame = rect.offsetBy(dx: col * (StatusPictureItemWidth + StatusPictureViewInnerMargin), dy: row * (StatusPictureItemWidth + StatusPictureViewInnerMargin))
            
            addSubview(iv)
        }
    }
}
