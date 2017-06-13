 //
//  StatusListViewModel.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/7.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
 import SDWebImage
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
    
    lazy var statusList = [StatusViewModel]()
    
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
        let since_id = pullUp ? 0 : (statusList.first?.status.id ?? 0)
        
        //上拉刷新, 取出数组中最后一条微博的id
        let max_id = !pullUp ? 0 : (statusList.last?.status.id ?? 0)
        
        
        // 上啦刷新, 取出数组的最后一条微博id
        
        
        
        NetManager.shareInstance.stausList(since_id: since_id, max_id: max_id) { (data, error) in
            
//            print(data)
            
            //0. 判断网络请求是否成功
            if error != nil {
                return
            }
            
            
            //1. 字典转模型
            //1> 定义结果可变 数组
            var array = [StatusViewModel]()
            
            //2> 便利服务器返回的字典数组, 字典转模型
            for dict in data ?? [] {
                
                //a) 创建微博模型 - 如果创建模型失败, 继续后续的便利
                guard let model = StatusItem.yy_model(with: dict) else {
                    continue
                }
                
                //b) 将试图模型 添加到数组
                array.append(StatusViewModel(model: model))
            }
            
            
//            guard let array = NSArray.yy_modelArray(with: StatusItem.self, json: data ?? []) as? [StatusItem] else {
//                
//                completionHandler(nil, error, false)
//                
//                return
//            }
            
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
                
                self.cacheSingleImage(list: array, completionHandler: completionHandler)
                
                
            }
            
            
        }
    }
    
    
    /// 缓存本次下载微博数据数组中的单张图像
    /// - 应该缓存完单张图像, 并且求该国配图视图大小之后, 再回调, 才能够保证表格等比例显示单张图像
    /// - Parameter list: 本次下载的视图模型数组
    fileprivate func cacheSingleImage(list: [StatusViewModel], completionHandler:@escaping (_ data: [[String: AnyObject]]?, _ error: NSError?,  _ shouldRefresh: Bool)->()) {
        //定义分组
        let group = DispatchGroup()
        
        //记录数据长度
        var length = 0
        
        //便利数组, 查找微博数据中有单张图像的进行缓存
        for vm in list {
            //1. 判断图像数量
            if vm.picURLs?.count != 1 {
                continue
            }
            
            //2. 代码执行到此, 数组中有且只有一张图片 获取url图像模型
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
            }
            
            //3. 下载图像
            //downloadImage 是 SDWebImage的和兴方法
            //图像下载完成之后, 会自动宝尊在沙河中, 文件路径是url的MD5
            //如果沙盒中已经存在缓存的图像, 会需使用SD通过url 加载图形都会加载本地沙盒的图像
            //不会发起网络请求, 同时回调方法同样会调用
            // 注意: 如果要缓存的图像累计很大, 找后台要接口
            // 和心方法 , 可以获得 图像的宽高
            // 使用这个方法下载下来的图片, 可以获得image, 并且可以通过image.size 获得 宽高, 然后更新
            //A> 入组
            group.enter()
            
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _) in
                
                //将图像转换成二进制
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    //NSData 是 length 属性
                    length += data.count
                    
                    //图像缓存成功, 更新配图视图的大小
                    vm.updateImageSize(image: image)
                    
                }
                
                print("缓存图像是\(String(describing: image))  长度\(length)")
                //B> 出组 - 放在回调的最后一句
                group.leave()
            });
            
        }
        
        //C>监听调度组情况
        group.notify(queue: DispatchQueue.main) { 
            print("图像缓存完成\(length / 1024)K")
            //4. 这里很定有值, 返回data
            completionHandler(nil, nil, true)
        }
    }
    
}
