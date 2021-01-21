//
//  createAnouncementPopup.swift
//  Inquire
//
//  Created by Henry Liu on 9/11/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

class createAnouncementPopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonRIght.roundedButton1()
        popView.layer.cornerRadius = 10
    }
    @IBOutlet weak var doneButtonRIght: UIButton!
    
    @IBOutlet weak var popView: UIView!
    
    @IBOutlet weak var doneButton: NSLayoutConstraint!
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    

}

extension UIButton{
    func roundedButton1(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
