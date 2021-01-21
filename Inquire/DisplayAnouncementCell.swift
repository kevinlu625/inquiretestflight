//
//  DisplayAnouncementCell.swift
//  Inquire
//
//  Created by Henry Liu on 8/15/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

class DisplayAnouncementCell: UITableViewCell {

    @IBOutlet weak var AnouncementText: UITextView!
    
    
    @IBOutlet weak var AnouncementTime: UILabel!
    
    
    @IBOutlet weak var AnouncementChannel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
