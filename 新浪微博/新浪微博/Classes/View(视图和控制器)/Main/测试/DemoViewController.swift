//
//  DemoViewController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class DemoViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置标题
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    @objc fileprivate func showNext() {
        let vc = DemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension DemoViewController {
    override func setupUI() {
        super.setupUI()
        
        //设置右边的控制器
        //Swift调用OC返回instancetype的方法,判断不出是否可选 加一个?
        
        //便利构造函数   
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", fontSize: 16, target: self, action: #selector(showNext))
    }
}
