//
//  WelcomeView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/9.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
import SDWebImage

///欢迎视图

class WelcomeView: UIView {

    //头像
    @IBOutlet weak var iconView: UIImageView!
    //欢迎
    @IBOutlet weak var tipLabel: UILabel!
    //底部约束
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    class func welcome()->WelcomeView {
        
        let nib = UINib(nibName: "WelcomeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WelcomeView
        //从xib中加载视图, 是600 x 600
        //在这里设置大小
        //注意层级不要覆盖了
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        //提示: initWithCoder, 只是刚刚从Xib的二进制文件将试图数据加载完成
//        //还没有和代码连线建立起关系, 所以开发时, 千万不要在这个方法中处理UI
//        print("initWithCoder+\(iconView)")
//    }
    
    override func awakeFromNib() {
        
       
    
        
        

        
        //1. url
        guard let urlString = NetManager.shareInstance.userAccount.avatar_large,
            let url = URL(string: urlString) ,
        let nameString = NetManager.shareInstance.userAccount.screen_name else {
            return
        }
        tipLabel.text = nameString
        
        //1. 设置头像- 如果不指定占位图像, 之前设置的图像会被清空
    iconView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "avatar_default_big"))
        
        //如果这里设置没有作用, 需要设置约束的宽高
        //设置圆角
        iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        //切图
        iconView.layer.masksToBounds = true
    }
    
    
    
    //自动布局系统更新完成约束后, 会自动调用此方法
    //通常是对自视图布局进行修改
//    override func layoutSubviews() {
//        
//    }
    
    //视图被添加到window 上, 表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //视图是使用自动布局来设置的, 知识设置了约束
        //当视图被添加到窗口上时, 根据父视图的大小, 计算约束值, 更新控件位置
        //如果控件们的frame还没有计算好, 调用layoutifneed, 会所有控件一起动画
        
        //执行之后, 控件所在位置, 就是xib中布局的位置, 相当于先有了位置, 在此前调用这个方法didMoveToWindow 还没有frame
        self.layoutIfNeeded()

        UIView.animate(withDuration: 1.5, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            //更新约束
            self.bottomConstraint.constant = self.bounds.size.height - 200
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: { 
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                //加载结束动画时候, 直接移除动画就好了
                self.removeFromSuperview()
            })
        }
    }

}
