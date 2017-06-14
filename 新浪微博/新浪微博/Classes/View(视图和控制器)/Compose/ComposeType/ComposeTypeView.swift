//
//  ComposeTypeView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/13.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
import pop
class ComposeTypeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    //关闭按钮约束
    @IBOutlet weak var closeButtonCenterX: NSLayoutConstraint!
    //返回前一页按钮
    @IBOutlet weak var gobackButton: UIButton!
    //返回前一页约束
    @IBOutlet weak var gobackCenterX: NSLayoutConstraint!
    /// 按钮数据数组
    fileprivate let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
                               ["imageName": "tabbar_compose_photo", "title": "照片/视频"],
                               ["imageName": "tabbar_compose_weibo", "title": "长微博"],
                               ["imageName": "tabbar_compose_lbs", "title": "签到"],
                               ["imageName": "tabbar_compose_review", "title": "点评"],
                               ["imageName": "tabbar_compose_more", "title": "更多", "actionName": "clickMore"],
                               ["imageName": "tabbar_compose_friend", "title": "好友圈"],
                               ["imageName": "tabbar_compose_wbcamera", "title": "微博相机"],
                               ["imageName": "tabbar_compose_music", "title": "音乐"],
                               ["imageName": "tabbar_compose_shooting", "title": "拍摄"]]
    
    
    
    class func composeTypeView() -> ComposeTypeView {
        let nib = UINib(nibName: "ComposeTypeView", bundle: nil)
        // 从 XIB加载完成视图, 就会调用awakeFromNib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ComposeTypeView
        
        //xib 默认是600 x 600
        v.frame = UIScreen.main.bounds
        
        v.setupUI()
        
        return v
        
    }
    @IBAction func close() {
        removeFromSuperview()
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
        //3. 开始动画
        showCurrentView()
    }
    
    

    
    //MARK: - 监听方法
    @objc fileprivate func clickButton() {
        print("点我了")
    }
    
    //返回上一页
    @IBAction func clickReturn() {
        //1. 滚动视图滚动到第一页
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //2. 让两个按钮隐藏
        gobackButton.isHidden = true
        
        closeButtonCenterX.constant = 0
        gobackCenterX.constant = 0
        
        UIView.animate(withDuration: 0.25, animations: { 
            //只要布局更新就调用这个方法
            self.layoutIfNeeded()
            self.gobackButton.alpha = 0
        }) { (_) in
            self.gobackButton.isHidden = true
            self.gobackButton.alpha = 1
        }
        
    }
    @objc fileprivate func clickMore () {
        print("点击了更多")
        //将scrollview 滚动到第二页
        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: true)
        
        //处理底部按钮, 让两个按钮分开
        gobackButton.isHidden = false
        
        let margin = scrollView.bounds.size.width / 6
        
        closeButtonCenterX.constant += margin
        gobackCenterX.constant -= margin
        
        UIView.animate(withDuration: 0.25) {
            //只要约束位置有变化, 就可以调用这个进行强制位置更新
            self.layoutIfNeeded()
        }
    }
    
}
//MARK: - 动画方法扩展
fileprivate extension ComposeTypeView {
    func showCurrentView()  {
        //1.创建动画
        let anim: POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 0.25
        
        //2. 添加到视图
        pop_add(anim, forKey: nil)
        //添加按钮的动画
        showButtons()
        
    }
    
    ///弹力显示所有按钮
    func showButtons()  {
        //1. 获取scrollview的自视图的第0个视图
        let v = scrollView.subviews[0]
        
        //2. 遍历v的所有按钮
        for (i, btn) in v.subviews.enumerated() {
            //1. 创建动画
            let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //2. 设置动画
            anim?.fromValue = btn.center.y + 400
            anim?.toValue = btn.center.y
            //弹力系数, 0 - 20
            anim?.springBounciness = 8
            //弹力速度0-20
            anim?.springSpeed = 8
            
            //设置动画起始时间
            anim?.beginTime = CACurrentMediaTime() + CFTimeInterval(i) * 0.025
            
            //3. 添加动画
            btn.pop_add(anim, forKey: nil)
        }
    }
}

//里面每个函数都是私有
fileprivate extension ComposeTypeView {
    func setupUI() {
        //有时候大小不对, 可能与代码调用顺序有关\
        //有时也需要强行更新布局来解决大小
        
        
        //0. 强行更新布局
        layoutIfNeeded()
        
        //1. 向scrolloview添加视图
        let rect = scrollView.bounds
        
        let width = scrollView.bounds.width
        
        for i in 0..<2 {
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i) * width, dy: 0))
            
            //2. 向视图添加按钮
            addButton(v: v, idx: i * 6)
            //3. 将试图添加到scrollView
            scrollView.addSubview(v)
            
        }
        
        //4. 设置scrollView
        scrollView.contentSize = CGSize(width: 2 * width, height: 0)
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        //5. 禁用滚动
        scrollView.isScrollEnabled = false
        
    }
    
    //向v中添加按钮, 按钮的数组索引从idx开始
    /*
     这里分两次布局
     第一次布局添加控件, 
     第二次布局设置位置
     */
    func addButton(v: UIView, idx: Int) {
        //从idx开始添加6个按钮
        let count = 6
        
        for i in idx..<(idx + count) {
            
            if i >= buttonsInfo.count {
                break
            }
            //0.从数组字典中获取图像名称和title
            let dict = buttonsInfo[i]
            guard let imageName = dict["imageName"],
                let title = dict["title"] else {
                    continue
            }
            
            
            //1. 创建按钮
            let btn = ComposeTypeButton.composeTypeButton(imageName: imageName, title: title)
            //2. 将btn添加到视图
            v.addSubview(btn)
            //3. 添加监听方法
            if let actionName = dict["actionName"] {
                //OC中使用NSSelectorFormString(@"clickMore")
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
        }
        
        //准备常量
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3 * btnSize.width) / 4
        
        //便利视图的子视图 布局按钮
        //注意这里是v.subViews
        for (i, btn) in v.subviews.enumerated() {
            
            let y: CGFloat = (i > 2) ? (v.bounds.height - btnSize.height) : 0
            let col = i % 3
            let x = CGFloat(col + 1) * margin + CGFloat(col) * btnSize.width
            
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
        }
        
        
        
    }
}


