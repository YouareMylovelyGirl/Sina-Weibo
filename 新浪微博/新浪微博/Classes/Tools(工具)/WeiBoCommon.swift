//
//  WeiBoCommon.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/7.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
import UIKit


//MARK: - 应用程序信息
//应用程序ID
let APPKey = "1659422547"
//39190169
//2715e085a21ca4f1083f3ff2544ee6cc
//------
//1659422547
//470bfdc420e5cdbcca12a60ffffba2da
//应用程序加密信息
let APPSecret = "470bfdc420e5cdbcca12a60ffffba2da"

//回调地址 - 登录完成跳转的URL, 参数以get形式拼接
let RedirectURI = "http://baidu.com"


//MARK: - 全局通知定义
//用户需要登录通知
let UserShouldLoginNotification = "UserShouldLoginNotification"
//用户登录成功通知
let UserLoginSuccessNotification = "UserLoginSuccessNotification"


//MARK: - 微博配图视图内部常量
//1. 计算配图视图的宽度
//配图视图外侧的间距
let StatusPictureViewOutterMargin = CGFloat(12)
//配图视图内部图像视图的间距
let StatusPictureViewInnerMargin = CGFloat(3)

//视图的宽度
let StatusPictureViewWidth = UIScreen.main.bounds.size.width - 2 * StatusPictureViewOutterMargin

//每个Item默认的高度
let StatusPictureItemWidth = ((StatusPictureViewWidth) - 2 * StatusPictureViewInnerMargin) / 3




