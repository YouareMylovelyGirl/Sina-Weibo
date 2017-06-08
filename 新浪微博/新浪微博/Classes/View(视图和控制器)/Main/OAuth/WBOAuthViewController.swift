//
//  WBOAuthViewController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/8.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
/// 通过webView加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {

    lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        
        //设置导航栏
        title = "登录新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", fontSize: 16, target: self, action: #selector(closeLoginView), isBack: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载授权界面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(APPKey)&redirect_uri=\(RedirectURI)"
        //1.> URL确定要访问的资源
        guard let url = URL(string: urlString) else {
            return
        }
        //2.> 建立请求
        let request = URLRequest(url: url)
        
        //3. > 加载请求
        webView.loadRequest(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func closeLoginView() {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
