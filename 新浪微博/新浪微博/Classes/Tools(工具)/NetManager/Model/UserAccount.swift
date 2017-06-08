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
    var access_token: String? //= "2.00UCb9cDnblSoB85b03aa45f5NfM6B"
    //用户代号
    var uid: String?
    //access_token的生命周期
    //开发者是5年
    //使用者三天
    var expires_in: TimeInterval = 0.0 {
        didSet {
            expirseDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    //过期日期
    var expirseDate: Date?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    /*
     1. 偏好设置 - 小
     2. 归档 / plist / json
     3. 数据库 - FMD / CoreData
     4. 钥匙串访问 - 小 - 自动加密 - 需要使用框架 - SSkeyChain
     */
    func saceAccount() {
        //1. 模型转字典
        var dict = (yy_modelToJSONObject() as? [String : AnyObject]) ?? [:]
        
        //需要删除 expires_in
        dict.removeValue(forKey: "expires_in")
        
        //2. 字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            return
        }
        
        //3. 写入磁盘
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
//        let fileName = "useraccount.json"
        
        let filePath = (docDir as NSString).appendingPathComponent("useraccount.json")
        
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功\(filePath)")
        
       
    }
}
