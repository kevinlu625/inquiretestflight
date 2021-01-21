//
//  pastRepliesCell.swift
//  Inquire
//
//  Created by Henry Liu on 8/17/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
class pastRepliesCell: UITableViewCell {

    @IBOutlet weak var User: UILabel!
    @IBOutlet weak var Timestamp: UILabel!
    @IBOutlet weak var comment: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var answerID = ""
    lazy var functions = Functions.functions()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    
    @IBAction func deleteReply(_ sender: Any) {
        print("FE RAN")
       UserData.currentAnswer = answerID
        UserData.currentReply = comment.text!
        
    }
    
}
