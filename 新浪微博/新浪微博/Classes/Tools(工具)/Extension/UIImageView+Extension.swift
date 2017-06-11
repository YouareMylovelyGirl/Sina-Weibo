//
//  UIImageView+Extension.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    
    /// 隔离SDWebImage设置图像函数
    ///
    /// - Parameters:
    ///   - urlString: urlString
    ///   - placeholderImage: 站位视图
    func yg_setImage(urlString: String?, placeholderImage: UIImage?)  {
        
        //处理URL
        guard let urlString = urlString,
            let url = URL(string: urlString)else {
            //设置站位图像
            image = placeholderImage
            return
        }
        
        
        //可选项只是用在 Swift, OC有时候用! 同样可以传入nil
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { (image, _, _, _) in
            
        }
    }
}
