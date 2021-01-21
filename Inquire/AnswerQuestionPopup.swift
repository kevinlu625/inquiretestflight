//
//  AnswerQuestionPopup.swift
//  Inquire
//
//  Created by Henry Liu on 8/19/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

class AnswerQuestionPopup: UIViewController {
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var submittedText: UILabel!
    var channelName  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        submittedText.text = "Your answer has been submitted to the " +  channelName + " channel"
        popupView.layer.cornerRadius = 10
        doneYes.roundedButton10()

    }
    
    @IBOutlet var doneButton: UIButton!
    
    @IBOutlet weak var doneYes: UIButton!
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
               self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)

    }
    
}

extension UIButton{
    func roundedButton10(){
        print("1")
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        print("1")
        let maskLayer1 = CAShapeLayer()
        print("2")
        maskLayer1.frame = bounds
        print("3")

        maskLayer1.path = maskPath1.cgPath
            print("4")

        layer.mask = maskLayer1
    }
}
