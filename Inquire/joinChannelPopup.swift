//
//  joinChannelPopup.swift
//  Inquire
//
//  Created by Henry Liu on 9/12/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

class joinChannelPopup: UIViewController {
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.roundedButton11()
        popupView.layer.cornerRadius = 10
        if joinedSuccess
        {
            joinChannelLabel.text! = "Successfully joined channel: " + channelName
        }
        else
        {
            joinChannelLabel.text! = "Unable to join Channel"
            doneButton.titleLabel?.text = "try again"
        }
        
    }
    @IBOutlet weak var joinChannelLabel: UILabel!
    var joinedSuccess = false
    var channelName = ""
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
 
    
    @IBOutlet weak var doneButton: UIButton!
    
}
extension UIButton
{
    func roundedButton11(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
