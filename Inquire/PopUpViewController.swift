

import UIKit

class PopUpViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    
    var channelName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        submittedText.text = "Your question has been submitted to the " +  channelName + " channel"
        doneButton.roundedButton8()
    }
    @IBOutlet weak var submittedText: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)

        
    }
}

extension UIButton{
    func roundedButton8(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

