//
//  StatusViewModel.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import Foundation
import UIKit

// 单条微博的视图模型

/*
 如果没有任何父类: 
 遵守CustomStringConvertible
 实现description 计算型属性
 
 //关于表格的性能优化
 - 尽量减少计算, 所有需要的素材提前计算好
 - 空间上不要设置, 所有图像渲染的属性, 都要注意!
 - 不要动态创建控件, 所有需要的控件, 都要提前创建好, 在显示提前创建好, 在显示额时候, 根据数据隐藏/ 显示!
 - cell中控件的层次越少越好
 
 */
class StatusViewModel:CustomStringConvertible {
    //微博模型
    var status: StatusItem
    
    ///会员图标
    var memberIcon: UIImage?
    ///认证类型
    var vipIcon: UIImage?
    
    //转发文字
    var retweetedStr: String?
    ///评论文字
    var commentStr: String?
    ///点赞文字
    var likeStr: String?
    //配图视图
    var pictureViewSize = CGSize()
    
    //如果是被转发的微博, 原创微博一定没有图
    var picURLs :[StatusPicture]? {
        //如果有被转发的微博, 返回被转发微博的配图
        //如果没有被转发的微博, 烦你原创微博的配图
        //如果都没有返回nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    //被转发微博文字
    var retweetedText: String?
    //行高
    var rowHeight: CGFloat = 0
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    init(model: StatusItem) {
        self.status = model
        //会员等级 0-6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        //设置底部计数字符串
        retweetedStr = countString(count: status.reposts_cout, defaultStr: "转发")
        commentStr = countString(count: status.comments_count, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count, defaultStr: "赞")
        
        
        //计算配图视图大小(有原创的就计算原创的, 有转发的就计算转发的)
        pictureViewSize = calcPictureViewSize(count: status.pic_urls?.count)
        
        // 设置被转发微博的文字
        retweetedText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":" + (status.retweeted_status?.text ?? "")
        
        //计算行高
        updateRowHeight()
        
    }
    
    ///根据当前的视图模型内容计算行高
    /*
      缓存行高步骤
     1. 打开XIB/ 纯代码一样, 从上相下的顺序, 依次罗列控件的高度公式
     2. 在试图模型中, 根据公式, 定义需要的常量, 间距, 图标, 表前视图计算大小, 标签的字体
     3. 定义变量height
     4. 从上向下, 依次计算, 不建议跳跃, 不要省略
     5. 计算
     6. 在构造函数末尾计算行高
     7, 在更新视图尺寸之后, 再次计算, 因为调整过配图视图的高度, 需要重新计算一下
     8, 调整控制器
     9. 取消自动行高
     */
    func updateRowHeight()  {
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        let viewSize = CGSize(width: UIScreen.main.bounds.size.width - 2 * margin, height: CGFloat(MAXFLOAT))
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        
        var height: CGFloat = 0
        //计算顶部位置
        height = 2 * margin + iconHeight + margin
        //2. 正文高度
        if let text = status.text {
            //两端固定, 上下填满
            
            /*
             1. 预期尺寸, 宽度固定, 高度尽量打
             2. 选项, 换行文本, 统一使用usesLineFramentOrigin
             3. attributes: 制定字典
             */
            height += (text as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: originalFont], context: nil).height
        }
        
        //3. 判断是否转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            //转发文本的高度 - 一定用 retweetedText. 拼接了 @用户名: 微博文字
            if let text = retweetedText {
                height += (text as NSString).boundingRect(with: viewSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: retweetedFont], context: nil).height
            }
        }
        
        //4. 配图视图
        height += pictureViewSize.height
        height += margin
        
        //5. 底部工具栏
        height += toolbarHeight
        
        //6.使用属性记录
        rowHeight = height
    }
    
    
    /// 使用单个图像, 更新配图视图的大小
    ///
    /// - Parameter image: 网络缓存的单张图像
    /// - 新浪针对单张图片, 都是缩略图, 但是偶尔会有一张大图
    
    ///新浪微博, 为了鼓励原创, 支持'长微博', 但是有的时候, 有特别长的微博, 长到宽度只有1个点
    func updateImageSize(image: UIImage)  {
        var size = image.size
        
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40
        
        
        //过宽图像处理
        if size.width > maxWidth {
            //设置最大宽度
            size.width = maxWidth
            //等比例调整高度
            size.height  = image.size.height / image.size.width * size.width
        }
        
        //过窄的图像处理
        if size.width < minWidth {
            size.width = minWidth
            //要特殊处理高度, 否则高度太大, 会影响用户体验 再多除以一个4
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        size.height += StatusPictureViewOutterMargin
        pictureViewSize = size
        
        //更新行高
        updateRowHeight()
    }
    
    /// 计算制定数量的图片对应的配图视图大小
    ///
    /// - Parameter count: 配图数量
    /// - Returns: 配图视图的大小
    fileprivate func calcPictureViewSize(count: Int?) -> CGSize {
        
        //这里使用|| 
        if count == 0 || count == nil{
            return CGSize()
        }
        
        //2. 计算高度
        //1> 根据count 知道行数1~9
        let row = (count! - 1) / 3 + 1
        //2> 根据行数算高度
        let height = StatusPictureViewOutterMargin + CGFloat(row) * StatusPictureItemWidth + CGFloat((row - 1)) * StatusPictureViewInnerMargin
        
        return CGSize(width: StatusPictureViewWidth, height: height)
    }
 
    
    var description: String {
        return status.description
    }
    
    /// 给定一个数字, 返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultStr: 默认字符串, 转发/ 评论/ 赞
    /// - Returns: 描述结果
    fileprivate func countString(count: Int, defaultStr: String) -> String {
        if count == 0 {
            return defaultStr
        }
        if count < 1000 {
            return count.description
        }
        
        return String(format: "%.02f 万", Double(count) / 10000)
    }
    
    
    
}
