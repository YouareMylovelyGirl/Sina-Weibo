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
            
            //测试修改配图视图的高度
            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            //设置配图视图的URL数据
            pictureView.urls = viewModel?.status.pic_urls
            
            //测试4张图片
//            if (viewModel?.status.pic_urls?.count)! > 4 {
//                //修改数组 -> 将末尾的数据全部删除
//                var picURLs = viewModel?.status.pic_urls!
//                picURLs?.removeSubrange(((picURLs?.startIndex)! + 4)..<(picURLs?.endIndex)!)
//                pictureView.urls = picURLs
//            } else {
//                pictureView.urls = viewModel?.status.pic_urls
//            }
            pictureView.urls = viewModel?.status.pic_urls
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
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
