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
    private let buttonsInfo = [["imageName": "tabbar_compose_idea", "title": "文字", "clsName": "WBComposeViewController"],
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
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! ComposeTypeView
        
        //xib 默认是600 x 600
        v.frame = UIScreen.main.bounds
        
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
    
    
    override func awakeFromNib() {
        setupUI()
    }
    
    //MARK: - 监听方法
    @objc fileprivate func clickButton() {
        print("点我了")
    }
    
}

//里面每个函数都是私有
fileprivate extension ComposeTypeView {
    func setupUI() {
        
    }
}
