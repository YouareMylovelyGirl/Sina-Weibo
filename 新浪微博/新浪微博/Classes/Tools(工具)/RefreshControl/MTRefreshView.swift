//
//  MTRefreshView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/13.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class MTRefreshView: RefreshView {

    @IBOutlet weak var kangarooIconView: UIImageView!
    
    @IBOutlet weak var buildingIconView: UIImageView!

    @IBOutlet weak var earthIconView: UIImageView!
    
    override var parentViewHeight: CGFloat {
        didSet {
            print("父视图\(parentViewHeight)")
            if parentViewHeight < 50 {
                return
            }
            var scale: CGFloat
            if parentViewHeight > 126 {
                scale = 1
            } else {
                
                //高度差 / 最大高度差
                 scale = 1 - ((126 - parentViewHeight) / (126 - 50))
            }
            
            kangarooIconView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
    }
    
    override func awakeFromNib() {
        //1. 房子
        let bImage1 = #imageLiteral(resourceName: "icon_building_loading_1")
        let bImage2 = #imageLiteral(resourceName: "icon_building_loading_2")
        //两张图换来换去
        buildingIconView.image = UIImage.animatedImage(with: [bImage1, bImage2], duration: 0.5)
        
        
        //2. 地球
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = -2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 3
        anim.isRemovedOnCompletion = false
        earthIconView.layer.add(anim, forKey: nil)
        
        //3. 袋鼠
        let cImage1 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_1")
        let cImage2 = #imageLiteral(resourceName: "icon_small_kangaroo_loading_2")
        //两张图换来换去
        kangarooIconView.image = UIImage.animatedImage(with: [cImage1, cImage2], duration: 0.3)
        
        kangarooIconView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        //1. 设置锚点
        kangarooIconView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        //2. 设置center
        let x = self.bounds.width * 0.5
        let y = self.bounds.height - 50
        kangarooIconView.center = CGPoint(x: x, y: y)
    }
}
