//
//  RefreshControl.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/12.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

/// 刷新控件
class RefreshControl: UIControl {
    
    //MARK: - 属性
    ///滚动视图的父视图, 下拉刷新控件应该适用于UITableView / UICollectionView
    private weak var scrollView: UIScrollView?
    
    
    //MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /*
     willMove: addSubView方法会调用
     - 当添加到父视图的时候, newSuperview是父视图
     - 当父视图被移除, newSuperview是nil
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        //记录父视图
        scrollView = sv
        
        
        //KVO 监听父视图的contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
    }
    
    //所有KVO方法会统一调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //contentOffset 的 y 值跟contentInset的top有关
//        print(change?[.newKey]!)

        guard let sv = scrollView else {
            return
        }
        //初始高度就应该是0
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        print(height)
        
        //可以根据高度设置刷新控件的frame
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
    }
    
    
    func beginRefreshing()  {
        setupUI()
    }
    
    func endRefreshing()  {
        setupUI()
    }

}


extension RefreshControl {
    fileprivate func setupUI() {
        backgroundColor = UIColor.orange
    }
}
