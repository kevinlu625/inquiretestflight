//
//  CommentTableViewCell.swift
//  
//
//  Created by Kevin Lu on 8/13/20.
//

import UIKit

class CommentTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var pfp: UIImageView!
    @IBOutlet weak var User: UILabel!
    @IBOutlet weak var Timestamp: UILabel!
    @IBOutlet weak var comment: UITextView!
    
    func resizeTextViewFrame()
    {
        comment?.delegate = self
        
        let fixedWidth = comment?.frame.size.width
        
        let newSize: CGSize = comment!.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat(MAXFLOAT)))
        
        var newFrame = comment!.frame
        
        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth!))), height: newSize.height)
        
        comment!.frame = newFrame
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
