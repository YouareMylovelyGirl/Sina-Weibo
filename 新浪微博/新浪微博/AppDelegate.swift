//
//  AppDelegate.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //用AFN加载网络数据
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["access_token": "2.00UCb9cD0VJ8eC0a8a9bbdf5S6IHwC"]

        
        NetManager.shareInstance.request(url: urlString, params: params, success: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
       
        
        
        //设置启动
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        //异步加载网络数据
        loadAppInfo()
        return true
    }

}

extension AppDelegate {
    fileprivate func loadAppInfo() {
        //1. 模拟异步
        DispatchQueue.global().async {
            //1> url
            let url = Bundle.main.url(forResource: "Main.json", withExtension: nil)
            //2> data
            let data = NSData(contentsOf: url!)
            //3> 写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let jsonPath = (docDir as NSString).appendingPathComponent("Main.json")
            
            //直接保存在沙盒, 等待下一次程序启动
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕\(jsonPath)")
        }
    }
}

