//
//  UserAccount.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/8.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

private let accountFile = "useraccount.json"

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
    //用户昵称
    var screen_name: String?
    //用户头像地址, 大图 180 * 180
    var avatar_large: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    
    override init() {
        super.init()
        //从磁盘加载保存的字典 -> 字典
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = (docDir as NSString).appendingPathComponent(accountFile as String)
        guard let data = NSData(contentsOfFile: filePath),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
            return
        }
        //2. 使用字典设置属性'
        yy_modelSet(with: dict ?? [:])
        
        print("从沙盒加载用户信息\(self)")
        
        //3. 判断token是否过期
        if expirseDate?.compare(Date()) != .orderedDescending {
            print("账户过期了")
            //清空token
            access_token = nil
            uid = nil
            
            //删除账户文件
            _ = try? FileManager.default.removeItem(atPath: filePath)
        }
        print("账户正常\(self)")
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
        
        let filePath = (docDir as NSString).appendingPathComponent(accountFile as String)
        
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功\(filePath)")
        
       
    }
}
