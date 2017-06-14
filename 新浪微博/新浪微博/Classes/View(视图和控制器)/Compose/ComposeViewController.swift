//
//  ComposeViewController.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/14.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init().randomColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", fontSize: 14, target: self, action: #selector(back), isBack: true)
    }
    
    @objc fileprivate func back() {
        dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
