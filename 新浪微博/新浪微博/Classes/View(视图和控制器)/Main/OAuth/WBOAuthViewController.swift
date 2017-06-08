//
//  WBOAuthViewController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/8.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit
import SVProgressHUD
/// 通过webView加载新浪微博授权页面控制器
class WBOAuthViewController: UIViewController {

    lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.white
        //取消滚动 - 新浪微博服务器, 返回的授权页面默认就是全屏
        webView.scrollView.isScrollEnabled = false
        
        
        
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
        let js = "document.getElementById('userId').value = '18710285537';" + "document.getElementById('passwd').value = 'personal';"
        //让webView直行js
        webView.stringByEvaluatingJavaScript(from: js)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func closeLoginView() {
        //关闭菊花
        SVProgressHUD.dismiss()
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
        if request.url?.absoluteString.hasPrefix(RedirectURI) == false {
           return true
        }
        
        
        //2.从http://baidu.com 回调地址的'查询字符串' 中查找 'code='
        //如果有授权成功, 否则, 授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            closeLoginView()
            
            return false
        }
        
        //3.从 query 字符串中取出授权码
        //代码走到此处, url中一定有查®询字符串, 包含'code'
        //"code=".endIndex 可以获取字符串的最后一个字符
        let index = "code=".endIndex
        let code = request.url?.query?.substring(from: index) ?? ""
        
        print("获取授权码--\(String(describing: code))")
        
//        print("加载请求--\(String(describing: request.url?.absoluteString))")
//        //query 就是url中 '?'后面的部分
//        print("加载请求--\(String(describing: request.url?.query))")
        return false
    }
    //开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        //展示hud
        SVProgressHUD.show()
    }
    //加载结束网页
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //取消hud
        SVProgressHUD.dismiss()
    }
    
}
