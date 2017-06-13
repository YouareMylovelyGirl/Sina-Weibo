//
//  StatusCell.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/9.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {
    
    var viewModel: StatusViewModel? {
        didSet {
            //微博文本
            statusLabel?.text = viewModel?.status.text
            //姓名
            nameLabel.text = viewModel?.status.user?.screen_name
            
            //设置会员图标 - 直接获取属性, 不需要比较
            memberIconView.image = viewModel?.memberIcon
            
            //认证图标
            vipIconView.image = viewModel?.vipIcon
            
            //用户图像
            iconView.yg_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named:"avatar_default_big"), isAvatar: true)
            //底部工具栏
            toolBar.viewModel = viewModel
            
            //配图视图的视图模型
            pictureView.viewModel = viewModel
            
            //测试修改配图视图的高度
//            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            //设置配图视图的URL数据(被转发和原创)
//            pictureView.urls = viewModel?.status.pic_urls
            //设置被转发微博的文字
            retweetedText?.text = viewModel?.retweetedText
            
            //测试4张图片
//            if (viewModel?.status.pic_urls?.count)! > 4 {
//                //修改数组 -> 将末尾的数据全部删除
//                var picURLs = viewModel?.status.pic_urls!
//                picURLs?.removeSubrange(((picURLs?.startIndex)! + 4)..<(picURLs?.endIndex)!)
//                pictureView.urls = picURLs
//            } else {
//                pictureView.urls = viewModel?.status.pic_urls
//            }
            
            //设置配图(被转发和原创)
//            pictureView.urls = viewModel?.picURLs
        }
    }
    
    ///头像
    @IBOutlet weak var iconView: UIImageView!
    ///姓名
    @IBOutlet weak var nameLabel: UILabel!
    ///会员
    @IBOutlet weak var memberIconView: UIImageView!
    ///时间
    @IBOutlet weak var timeLabel: UILabel!
    ///来源
    @IBOutlet weak var sourceLabel: UILabel!
    ///认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    ///正文
    @IBOutlet weak var statusLabel: UILabel!
    //底部工具栏
    @IBOutlet weak var toolBar: StatusToolBar!
    //配图视图
    @IBOutlet weak var pictureView: StatusPictureView!
    
    @IBOutlet weak var retweetedText: UILabel?
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 离屏渲染
        self.layer.drawsAsynchronously = true
        //栅栏化 (shan ge hua)之后, 会生成一张独立的图像, cell在屏幕上滚动的时候, 本质上滚动的是这张图片
        // cell的优化, 要尽量减少图层的数量, 相当于只有一层, 停止滚动的时候可以接受监听
        self.layer.shouldRasterize = true
        //使用栅栏化 必须制定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    

}
