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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
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
        
        //webView 设置代理
        webView.delegate = self
        
    }
    
    //自动填充 - webView的注入, 直接通过js修改 本地的浏览器中缓存的页面内容
    //点击登录按钮执行submit, 将本地的数据提交给服务器
    @objc private func autoFill() {
        //准备 js
        let js = "document.getElementById('userId').value = '18710285537';" + "document.getElementById('passwd').value = 'person';"
        //让webView直行js
        webView.stringByEvaluatingJavaScript(from: js)
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

extension WBOAuthViewController: UIWebViewDelegate {
    
    /// 将要加载秦秋
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 要价在等请求
    ///   - navigationType: 导航类型
    /// - Returns: 是否加载request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        //确认思路: 
        //1.如果请求地址包含 http://baidu.com 不加载页面/ 否则加载页面
        //2.从http://baidu.com 回调地址的'查询字符串' 中查找 'code='
        //如果有授权成功, 否则, 授权失败
        
        
        print("加载请求--\(String(describing: request.url?.absoluteString))")
        return true
    }
}
