//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
import UIKit

// 单条微博的视图模型

/*
 如果没有任何父类: 
 遵守CustomStringConvertible
 实现description 计算型属性
 
 //关于表格的性能优化
 - 尽量减少计算, 所有需要的素材提前计算好
 - 空间上不要设置, 所有图像渲染的属性, 都要注意!
 - 不要动态创建控件, 所有需要的控件, 都要提前创建好, 在显示提前创建好, 在显示额时候, 根据数据隐藏/ 显示!
 - cell中控件的层次越少越好
 
 */
class StatusViewModel:CustomStringConvertible {
    //微博模型
    var status: StatusItem
    
    ///会员图标
    var memberIcon: UIImage?
    
    var vipIcon: UIImage?
    
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model: StatusItem) {
        self.status = model
        //会员等级 0-6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        
    }
 
    
    var description: String {
        return status.description
    }
}
