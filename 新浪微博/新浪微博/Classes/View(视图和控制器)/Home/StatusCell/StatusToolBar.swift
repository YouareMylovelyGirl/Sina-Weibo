//
//  StatusToolBar.swift
//  新浪微博
//
//  Created by 阳光 on 2017/6/11.
//  Copyright © 2017年 YG. All rights reserved.
//

import UIKit

class StatusToolBar: UIView {
    
    var viewModel: StatusViewModel? {
        didSet {
            retweetedButton.setTitle("\(viewModel?.status.reposts_cout ?? 0)", for: .normal)
            commentButton.setTitle("\(viewModel?.status.comments_count ?? 0)", for: .normal)
            likeButton.setTitle("\(viewModel?.status.attitudes_count ?? 0)", for: .normal)
        }
    }
    
    
    ///转发
    @IBOutlet weak var retweetedButton: UIButton!
    ///评论
    @IBOutlet weak var commentButton: UIButton!
    ///点赞
    @IBOutlet weak var likeButton: UIButton!

}
