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
    
    //重写description的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
}
