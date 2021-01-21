//
//  UserCell.swift
//  Inquire
//
//  Created by Henry Liu on 8/15/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
class UserCell: UITableViewCell {

   
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var username: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(channelAdmin)
        print("init")
        
    }
    var channelAdmin = ""
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }
    lazy var functions = Functions.functions()
    
    
    
    
    
}
