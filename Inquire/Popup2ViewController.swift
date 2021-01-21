//
//  Popup2ViewController.swift
//  
//
//  Created by Kevin Lu on 8/9/20.
//

import UIKit

class Popup2ViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var onCreatedText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
            popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        var channel = UserData.currentChannel
            
        onCreatedText.text = "Your channel \"" + channel.trimmingCharacters(in: .whitespacesAndNewlines) + "\" has been created"
        doneButton.roundedButton()
    }

    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        popupView.alpha = 0

        performSegue(withIdentifier: "createChannelToLoading", sender: self)
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (Timer) in
            self.dismiss(animated: true
            , completion: nil)
            self.dismiss(animated: false, completion: nil)
            Timer.invalidate()

            }
    }
    
}

extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
