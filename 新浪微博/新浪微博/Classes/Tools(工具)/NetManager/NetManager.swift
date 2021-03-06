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
    
    //用户账户的懒加载属性
    lazy var userAccount = UserAccount()
    //用户登录标记[计算型属性]
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    //单例  静态区/常量/闭包/
    //在第一次访问时执行闭包,并且将结果保存在sharedManager中
//    static let sharedManager = NetManager()
    
    // 使用一个函数封装AFN的 GET/POST请求
    static let shareInstance : NetManager = {
        let tool = NetManager()
        tool.requestSerializer = AFHTTPRequestSerializer()
        tool.responseSerializer = AFJSONResponseSerializer()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tool.requestSerializer.timeoutInterval = 10
        return tool
    }()

    /// 修改后的网络请求
    ///
    /// - Parameters:
    ///   - requestType: 请求方式
    ///   - url: URLString
    ///   - params: 请求参数
    ///   - completionHandler: data和error
    func request(requestType: HTTPMethod = .GET, url : String, params: [String : Any]?, completionHandler: @escaping([String : Any]?, _ error : Error?) ->()){
        //成功
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
//            completionHandler(responseObj as? [String : Any], nil)
            completionHandler(responseObj as? [String : Any], nil)
        }
        
        
        //对于测试用户(应用程序还没有提交给新浪微博审核)每天的刷新量是有限的!
        //超出了会被锁定
        //解决办法, 新建一个应用程序
        //失败
        let failureBlock = {(task : URLSessionDataTask?,error:Error) in
            print(error)
            //针对403处理永辉token过期
            //如果父类要往子类转需要做强制类型转换
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token过期了")
                
                UserAccount().access_token = nil
                UserAccount().uid = nil
                
                // 发送通知, 提示用户在此登录(本方法不知道被谁调用, 谁接收到通知谁处理)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: "bad token")
                
            }
            
            
//            completionHandler(nil, error)
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
    
    
    
    ///专门负责拼接 token 的网络请求方法  判断token是否存在
    func tokenRequest(requestType: HTTPMethod = .GET, url : String, params: [String : Any]?, completionHandler: @escaping([String : Any]?, _ error : Error?) ->()) {
        //处理token字典
        //0. 判断token是否为nil, 为nil直接返回, 程序执行过程中, 一般token不会为nil
        guard let token = userAccount.access_token else {
            print("没有token!需要登录")
            //发送通知提示用户登录
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: UserShouldLoginNotification), object: nil)
            
            return
        }
        
        //处理真正的token
        //1. 判断参数字典是否存在, 如果为nil应该新建一个字典
        var params = params
        
        if params == nil {
            //实例化字典
            params = [String: AnyObject]()
        }
        
        //2. 这是参数字典 代码在此处一定有值
        params!["access_token"] = token
        
        
        //调用request发起真正的网络请求方法
        request(url: url, params: params, completionHandler: completionHandler)
        
    }
    
    
}









    

