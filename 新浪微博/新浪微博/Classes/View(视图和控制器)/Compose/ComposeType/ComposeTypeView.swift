//
//  ComposeTypeView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/13.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class ComposeTypeView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
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
    }
    
    

    
    //MARK: - 监听方法
    @objc fileprivate func clickButton() {
        print("点我了")
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
            
            v.addSubview(btn)
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
