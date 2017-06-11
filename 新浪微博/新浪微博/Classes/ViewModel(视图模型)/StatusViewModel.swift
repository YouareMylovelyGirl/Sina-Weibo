//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
// 单条微博的视图模型
class StatusViewModel {
    //微博模型
    var status: StatusItem
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model: StatusItem) {
        self.status = model
    }
    
}
