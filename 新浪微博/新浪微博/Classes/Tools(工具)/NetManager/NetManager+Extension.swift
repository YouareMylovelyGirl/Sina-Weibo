//
//  NetManager+Extension.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/7.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
//封装新浪微博的网络请求方法
extension NetManager {
    
    /// 加载微博字典数据
    ///   - since_id: 则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    ///   - max_id: 则返回ID小于或等于max_id的微博，默认为0。
    ///   - Parameter completionHandler: 完成回调   [list: 微博字典数组/错误信息]

    func stausList( since_id: Int64 = 0, max_id: Int64 = 0, completionHandler: @escaping (_ list: [[String: AnyObject]]?, _ error : NSError? ) -> ()) {
        //用AFN加载网络数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
//        let params = ["access_token": "2.00UCb9cD0VJ8eC0a8a9bbdf5S6IHwC"]
        
        //Swift 中 Int 可以转换成AnyObject / 但是Int64 不行, 但是可以将Int64 装换成字符串
        let params = ["since_id": "\(since_id)",
            "max_id": "\(max_id > 0 ?max_id - 1 : 0)"]
        
        //提示: 服务器返回的字典, 就是按照时间倒序排序的
        
        tokenRequest(url: urlString, params: params) { (json, error) in
            
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completionHandler(result, error as NSError?)
        }
        
    }
    
    //定时刷新不需要提示失败
    ///返回微博的未读数量
    func unreadCount(completionHandler:@escaping (_ count: Int)->()) {
        guard let uid = userAccount.uid else { return  }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        
        tokenRequest(url: urlString, params: params) { (data, error) in
            let dic = data as [String: AnyObject]?
            let count = dic?["status"] as? Int
            completionHandler(count ?? 0)
        }
    }
 
}
//MARK: - OAuth相关方法
extension NetManager {
    //加载accessToken
    
    /// 加载AccessToken
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completionHandler: 完成回调
    func loadAccessToken(code: String, completionHandler:@escaping (_ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": APPKey,
                      "client_secret": APPSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": RedirectURI]
        
        //发起网络请求
        request(requestType: .POST, url: urlString, params: params) { (data, error) in
            //直接用字典设置 userAccount属性
            self.userAccount.yy_modelSet(with: (data as [String: AnyObject]?) ?? [:])
            print(self.userAccount)
            
            //保存模型
            self.userAccount.saceAccount()
            
            //完成回调
            if error == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
    
        }
        
    }

}
