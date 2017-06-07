//
//  HomeController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/5.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

//定义全局常量, 尽量使用private修饰, 要不然导出都能使用
fileprivate let cellID = "cellID"

class HomeController: BaseViewController {
    
    //列表视图模型
    fileprivate lazy var listViewModel = StatusListViewModel()
    
    
    
    /// 显示好友
    @objc fileprivate func showFriends() {
        print(#function);
        let vc = DemoViewController()
        //控制器push时隐藏下面的条, 弊端就是容易忘记
//        vc.hidesBottomBarWhenPushed = true
        //push 的动作是nav做的
        navigationController?.pushViewController(vc, animated: true)
    }

    //加载数据
    override func loadData() {
        
        print("准备刷新, 最后一条\(String(describing: self.listViewModel.statusList.last?.text))")
        listViewModel.loadStatus(pullUp: self.isPullup) { (error) in
            print("加载数据结束")
            //结束刷新控件
            self.refreshControl?.endRefreshing()
            //恢复上拉刷新标记
            self.isPullup = false
            self.tableView?.reloadData()
        }
        
    }
}

// MARK: - 表格数据源方法, 具体的数据源方法实现,不需要super
extension HomeController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. 取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,for: indexPath)
        //2. 设置cell
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
        //3. 返回cell
        return cell
    }
}


// MARK: - 设置界面
extension HomeController {
    
    /*
     父类写了一个方法, 子类去重写这个方法, 这样就能做到每一个控制器定制化
     */
    
    override func setupTableView() {
        super.setupTableView()
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", fontSize: 16, target: self, action: #selector(showFriends))

        //这里需要先注册原形cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    
    //重写父类方法
//    override func setupUI() {
//        super.setupUI()
//        //设置导航栏按钮
//        //Swift调用OC返回instancetype的方法,判断不出是否可选
//        //便利构造函数
//        
//        //Swift中的便利构造函数就相当关于OC中的重写构造函数 init
//        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", fontSize: 16, target: self, action: #selector(showFriends))
//        
//        //这里需要先注册原形cell
//        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
//        
//    }
}
