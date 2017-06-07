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
    ///
    /// - Parameter completionHandler: 完成回调   [list: 微博字典数组/错误信息]
    func stausList(completionHandler: @escaping (_ list: [[String: AnyObject]]?, _ error : NSError? ) -> ()) {
        //用AFN加载网络数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["access_token": "2.00UCb9cD0VJ8eC0a8a9bbdf5S6IHwC"]
        
        request(url: urlString, params: params) { (json, error) in
            
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completionHandler(result, error as NSError?)
        }
        
    }
    
}
