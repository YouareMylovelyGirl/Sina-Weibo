//
//  User.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class User: NSObject {
    //基本数据类型不能能够设置可选 & private不能够使用KVC
    //用户id
    var id: Int64 = 0
    //用户昵称
    var screen_name: String?
    //用户头像地址(中国) 50 * 50
    var profile_image_url: String?
    //认证类型 -1: 没有认证, 0: 认证 , 2,3,5企业认证, 220: 达人
    var verified_type: Int = 0
    //会员等级
    var mbrank: Int = 0
    
    
    
    override var description: String {
        return yy_modelDescription()
    }
}
