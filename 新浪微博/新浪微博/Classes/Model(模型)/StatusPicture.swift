//
//  StatusPicture.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
//微博配图模型
class StatusPicture: NSObject {
    //缩略图地址
    var thumbnail_pic: String?
    
    override var description: String {
        return yy_modelDescription()
    }
}
