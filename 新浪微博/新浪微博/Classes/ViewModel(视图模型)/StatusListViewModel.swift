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

private let maxPullupTryTimes = 3

class StatusListViewModel {
    
    lazy var statusList = [StatusItem]()
    
    private var pullErrorTimes = 0
    
    /// 加载微博列表
    /// - pullUp: 是否上拉刷新标记
    /// - Parameter completionHandler: 完成回调判断是否成功, 是否需要刷新更多数据
    func loadStatus(pullUp: Bool, completionHandler:@escaping (_ data: [[String: AnyObject]]?, _ error: NSError?,  _ shouldRefresh: Bool)->()) {
        
        //判断是否是上啦刷新, 同时检查刷新错误
        if pullUp && pullErrorTimes > maxPullupTryTimes {
            
            completionHandler(nil, nil, false)
            return
        }
        
        
        // since_id 取出数组中第一条微博的id,, 下拉刷新
        let since_id = pullUp ? 0 : (statusList.first?.id ?? 0)
        
        //上拉刷新, 取出数组中最后一条微博的id
        let max_id = !pullUp ? 0 : (statusList.last?.id ?? 0)
        
        
        // 上啦刷新, 取出数组的最后一条微博id
        
        
        
        NetManager.shareInstance.stausList(since_id: since_id, max_id: max_id) { (data, error) in
            
//            print(data)
            
            //1. 字典转模型
            guard let array = NSArray.yy_modelArray(with: StatusItem.self, json: data ?? []) as? [StatusItem] else {
                
                completionHandler(nil, error, false)
                
                return
            }
            
            print("刷新到\(array.count)条数据")
            
            //2. FIXME拼接数据
            if pullUp {
                //上啦刷新结束后, 将结果拼接在数组末尾
                self.statusList += array
            } else {
                //下拉刷新, 应该将结果数组拼接在数组前面
                self.statusList = array + self.statusList
            }
            
            //3. 判断上啦刷新的数据量
            if pullUp && array.count == 0 {
                self.pullErrorTimes += 1
                completionHandler(data, nil, false)
                
            } else {
                
            }
            
            //3. 这里很定有值, 返回data
            completionHandler(data, nil, true)
        }
    }
}
