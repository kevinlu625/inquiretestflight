//
//  LeaderboardTableViewCell.swift
//  Inquire
//
//  Created by Kevin Lu on 12/25/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var pfp: UIImageView!
    
    @IBOutlet weak var username: UITextView!
    
    @IBOutlet weak var points: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let fixedWidth = username.frame.size.width
        let newSize = username.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        username.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        username.isScrollEnabled = false
        //username.frame.size = username.intrinsicContentSize
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
