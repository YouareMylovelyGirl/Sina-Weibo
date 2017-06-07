//
//  StatusListViewModel.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/7.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
//微博数据列表视图模型
/*
 父类的选择,如果需要使用KVC 或者字典转模型框架设置对象, 累就需要继承自NSObject
 如果类只是包装一些代码逻辑(写了一些函数), 可以不用任何父类, 好处: 更加轻量级
 提示: 如果用OC写一律都继承自NSObject
 
 使命: 负责微博的数据处理
 1. 字典转模型
 2. 下拉 / 上啦数据处理
 */
class StatusListViewModel {
    
    lazy var statusList = [StatusItem]()
    
    /// 加载微博列表
    ///
    /// - Parameter completionHandler: 完成回调判断是否成功
    func loadStatus(completionHandler:@escaping (_ data: [[String: AnyObject]]?, _ error: NSError?)->()) {
        NetManager.shareInstance.stausList { (data, error) in
            
//            print(data)
            
            //1. 字典转模型
            guard let array = NSArray.yy_modelArray(with: StatusItem.self, json: data ?? []) as? [StatusItem] else {
                
                completionHandler(nil, error!)
                
                return
            }
            //2. 拼接数据
            self.statusList += array
            //3. 这里很定有值, 返回data
            completionHandler(data, nil)
        }
    }
}
