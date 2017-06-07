//
//  NetManager.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/7.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
import AFNetworking

//Swift的枚举支持任意数据类型
// Swift / enum 在OC中都只是支持整数
enum HTTPMethod {
    case GET
    case POST
}

//网络管理工具
class NetManager: AFHTTPSessionManager {
    
    //单例  静态区/常量/闭包/
    //在第一次访问时执行闭包,并且将结果保存在sharedManager中
//    static let sharedManager = NetManager()
    
    // 使用一个函数封装AFN的 GET/POST请求
    static let shareInstance : NetManager = {
        let tool = NetManager()
        tool.requestSerializer = AFHTTPRequestSerializer()
        tool.responseSerializer = AFJSONResponseSerializer()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        tool.requestSerializer.timeoutInterval = 10
        return tool
    }()
    
    /// 封装AFN的GET/POST请求
    ///
    /// - Parameters:
    ///   - requestType: HTTP请求格式
    ///   - url: URLString
    ///   - params: 参数字典
    ///   - success: 成功时候的回调
    ///   - failure: 失败时的回调
//    func request(requestType: HTTPMethod = .GET, url : String, params: [String : Any], success: @escaping([String : Any]?) ->(),failure: @escaping( _ error : Error?) -> ()){
//        //成功
//        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
//            success(responseObj as? [String : Any])
//        }
//        
//        //失败
//        let failureBlock = {(task : URLSessionDataTask?,error:Error) in
//            failure(error)
//        }
//        
//        //GET
//        if requestType == .GET {
//            get(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
//            
//        }
//        
//        //POST
//        if requestType == .POST {
//            post(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
//
//        }
//    }
    
    
    
    
    /// 修改后的网络请求
    ///
    /// - Parameters:
    ///   - requestType: 请求方式
    ///   - url: URLString
    ///   - params: 请求参数
    ///   - completionHandler: data和error
    func request(requestType: HTTPMethod = .GET, url : String, params: [String : Any], completionHandler: @escaping([String : Any]?, _ error : Error?) ->()){
        //成功
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            completionHandler(responseObj as? [String : Any], nil)
        }
        
        //失败
        let failureBlock = {(task : URLSessionDataTask?,error:Error) in
            print(error)
            completionHandler(nil, error)
        }
        
        //GET
        if requestType == .GET {
            get(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
            
        }
        
        //POST
        if requestType == .POST {
            post(url, parameters: params, progress: nil, success: successBlock, failure: failureBlock)
            
        }
    }
}









    

