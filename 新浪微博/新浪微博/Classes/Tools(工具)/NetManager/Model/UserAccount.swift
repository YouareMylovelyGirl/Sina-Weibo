//
//  UserAccount.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/8.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
//用户信息
class UserAccount: NSObject {
    //访问令牌
    var access_token: String?
    //用户代号
    var uid: String?
    //access_token的生命周期
    //开发者是5年
    //使用者三天
    var expires_in: TimeInterval = 0.0
    
    override var description: String {
        return yy_modelDescription()
    }
}
