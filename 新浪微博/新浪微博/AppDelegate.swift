//
//  AppDelegate.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
//iOS 10推出用户提醒
import UserNotifications
import SVProgressHUD
import AFNetworking


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //应用程序额外设置
        setupAdditions()

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
//MARK: - 设置应用程序额外信息
extension AppDelegate {
    fileprivate func setupAdditions() {
        //1. 设置 SVPregressHUD 最小接触时间
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        //2. 设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        //3. 设置用户授权显示通知
        //最新用户提示 是检测设备版本, 如果是10.0 以上
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .carPlay]) { (success, error) in
                print("授权" + (success ? "成功" : "失败")
                )}
        } else {
            //取得用户授权显示通知"上方的提示条/ 声音/ BadgeNumber"  过期方法 10.0 一下
            let notifySetting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            //这是一个单利
            UIApplication.shared.registerUserNotificationSettings(notifySetting)
        }
    }
}


//从服务器加载应用程序信息
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

