//
//  NewFeatureView.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/9.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class NewFeatureView: UIView {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    
    //进入微博
    @IBAction func enterStatus() {
        //点击进入按钮, 也需要remove
        self.removeFromSuperview()
    }
    
    
    class func newFeature()->NewFeatureView {
        
        let nib = UINib(nibName: "NewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! NewFeatureView
        //从xib中加载视图, 是600 x 600
        //在这里设置大小
        //注意层级不要覆盖了
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        //如果使用自动布局设置的界面, 从xib加载默认是600 * 600大小
        //添加4个图像视图
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            let imageName = "new_feature_\(i+1)"
            let iv  = UIImageView(image: UIImage.init(named: imageName))
            
            //设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollView.addSubview(iv)
        }
        
        //指定scrollView的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.delegate = self
        
        //隐藏按钮
        enterButton.isHidden = true
    }
}


// MARK: - UIScrollViewDelegate
extension NewFeatureView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //1. 滚动到最后一屏, 让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        //2. 判断是否最后 一页
        if page == scrollView.subviews.count {
            print("删除了")
            removeFromSuperview()
        }
        
        //3. 如果是 倒数第二页, 显示按钮
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0. 视图一滚动, 登录按钮就藏起来
        enterButton.isHidden = true
        
        //1. 计算当前偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        //3. 设置分页控件
        pageControl.currentPage = page
        
        //4. 分也控件隐藏 根据contentOffSet.x 来进行判断是否隐藏
        let hidePageWidth = CGFloat((scrollView.subviews.count - 1)) * (scrollView.bounds.size.width)
        if scrollView.contentOffset.x > hidePageWidth {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
        
    }
}
