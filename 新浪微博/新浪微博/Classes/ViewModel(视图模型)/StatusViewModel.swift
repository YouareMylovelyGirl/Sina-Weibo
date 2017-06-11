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
    ///认证类型
    var vipIcon: UIImage?
    
    //转发文字
    var retweetedStr: String?
    ///评论文字
    var commentStr: String?
    ///点赞文字
    var likeStr: String?
    //配图视图
    var pictureViewSize = CGSize()
    
    
    
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
        
        //设置底部计数字符串
        retweetedStr = countString(count: status.reposts_cout, defaultStr: "转发")
        commentStr = countString(count: status.comments_count, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count, defaultStr: "赞")
        
        
        //计算配图视图大小
        pictureViewSize = calcPictureViewSize(count: status.pic_urls?.count)
        
    }
    
    /// 计算制定数量的图片对应的配图视图大小
    ///
    /// - Parameter count: 配图数量
    /// - Returns: 配图视图的大小
    fileprivate func calcPictureViewSize(count: Int?) -> CGSize {
        
        //这里使用|| 
        if count == 0 || count == nil{
            return CGSize()
        }
        
        //2. 计算高度
        //1> 根据count 知道行数1~9
        let row = (count! - 1) / 3 + 1
        //2> 根据行数算高度
        let height = StatusPictureViewOutterMargin + CGFloat(row) * StatusPictureItemWidth + CGFloat((row - 1)) * StatusPictureViewInnerMargin
        
        return CGSize(width: StatusPictureViewWidth, height: height)
    }
 
    
    var description: String {
        return status.description
    }
    
    /// 给定一个数字, 返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultStr: 默认字符串, 转发/ 评论/ 赞
    /// - Returns: 描述结果
    fileprivate func countString(count: Int, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        if count < 1000 {
            return count.description
        }
        
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    
    
}
