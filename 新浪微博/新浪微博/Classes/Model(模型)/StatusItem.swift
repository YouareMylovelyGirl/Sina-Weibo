//
//  StatusItem.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/7.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
import YYModel

//微博数据模型
class StatusItem: NSObject {
    //Int 类型, 在64位的机器是64的, 在32位机器就是32位的
    //如果不写Int64, 在老一些设备 5/5c/4/4s/iPad2 数据会溢出
    var id: Int64 = 0
    //微博数据内容
    var text: String?
    /// 微博用户
    var user: User?
    //转发数
    var reposts_cout: Int = 0
    //评论数
    var comments_count: Int = 0
    //点赞数
    var attitudes_count: Int = 0
    //被转发的原创微博
    var retweeted_status: StatusItem?
    //微博创建时间字符串
    var created_at: String?
    //来源 - 发布微博使用的客户端
    var source: String? {
        didSet {
            //重新计算来源并且保存
            //在didSet中, 给source在此设置值, 不会调用didSet
            source = "来自 " + (source?.yg_href()?.text ?? "")
        }
    }
    
    
    //微博配图模型数组
    var pic_urls: [StatusPicture]?
    
    
    //重写description的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    //类函数 -> 告诉第三方框架, 如果遇到数组类型的属性, 数组中存放的对象是什么类?
    //NSArray中 保存对象的类型通常是`id`类型
    //OC中的泛型Swift退出后, 苹果为了兼容给OC增加的, 从运行时角度, 仍然不知道数组中应该存放什么类型的对象
    
    class func modelContainerPropertyGenericClass() ->[String : AnyObject]? {

        return ["pic_urls": StatusPicture.self]
        
    }
    
}
