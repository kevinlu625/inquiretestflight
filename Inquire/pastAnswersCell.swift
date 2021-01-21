//
//  pastAnswersCell.swift
//  Inquire
//
//  Created by Kevin Lu on 1/2/21.
//  Copyright © 2021 Henry Liu. All rights reserved.
//

import UIKit

class pastAnswersCell: UITableViewCell {
    
    @IBOutlet weak var channelName: UILabel!
    
    @IBOutlet weak var dateTime: UILabel!
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var answer: UILabel!
    
    @IBOutlet weak var counter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        channelName.frame.size = channelName.intrinsicContentSize
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
