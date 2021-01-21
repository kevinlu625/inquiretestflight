//
//  PopUp3ViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 8/9/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import UIKit
import FirebaseFunctions
protocol DeleteRowInTableviewDelegate: NSObjectProtocol {
    func deleteRow(inTableview rowToDelete: Int)
}

class PopUp3ViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    var delegate: DeleteRowInTableviewDelegate?

    @IBOutlet weak var leaveChannelLabel: UILabel!
    lazy var functions = Functions.functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        leaveChannelLabel.text = "leave channel \"" + UserData.currentChannel + "\"?"
        popupView.layer.cornerRadius = 10
        deleteButton.roundedButton3()
        if isMovingFromParent {
            delegate?.deleteRow(inTableview: 1)
        }
        //cancelB.layer.borderWidth = 1
        //cancelB.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @IBOutlet weak var cancelB: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func cancelButton(_ sender: Any)
    {
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        let userName = UserData.currentUser
               //private channel
        functions.httpsCallable("leaveChannel").call(["userName": userName, "channelID":UserData.currentChannel])
        {
            (result, error) in
                if let error = error as NSError?
                {
                    if error.domain == FunctionsErrorDomain
                    {
                        let code = FunctionsErrorCode(rawValue: error.code)
                        let message = error.localizedDescription
                        let details = error.userInfo[FunctionsErrorDetailsKey]
                    }
                }
                   print("left")
        }
        
        print("Delete Channel")
        popupView.alpha = 0
        self.performSegue(withIdentifier: "leaveChannelToLoading",sender: self)
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (Timer) in
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            Timer.invalidate()
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIButton{
    func roundedButton3(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

