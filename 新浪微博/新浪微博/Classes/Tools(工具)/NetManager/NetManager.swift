//
//  NetManager.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/7.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
import AFNetworking

//网络管理工具
class NetManager: AFHTTPSessionManager {
    
    //单例  静态区/常量/闭包/
    //在第一次访问时执行闭包,并且将结果保存在sharedManager中
    static let sharedManager = NetManager()
}
