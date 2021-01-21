//
//  contentReportedPopup.swift
//  Inquire
//
//  Created by Henry Liu on 9/19/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

class contentReportedPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        doneButton.roundedButton12()
    }
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
   
}

extension UIButton
{
    func roundedButton12(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
