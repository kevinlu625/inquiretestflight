//
//  blockedUserCell.swift
//  Inquire
//
//  Created by Henry Liu on 9/26/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import Firebase
class blockedUserCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var functions = Functions.functions()
    @IBAction func unblockUser(_ sender: Any) {
        
        
        functions.httpsCallable("unblockUser").call(["blocker":UserData.currentUser,"unblocked":username.text])
        { (HTTPSCallableResult, Error) in
            if let error = Error as NSError?
            {
                print(error.localizedDescription)
                
            }
            print("done")
            
        }
        
    }
    
    

}
