//
//  Bundle+Extensions.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
extension Bundle {
    //计算性属性类似于函数, 没有参数, 有返回值
    var namespace: String {
        return (infoDictionary?["CFBundleName"] as? String) ?? ""
    }
}
