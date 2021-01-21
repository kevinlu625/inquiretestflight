//
//  deleteChannelPopup.swift
//  Inquire
//
//  Created by Henry Liu on 8/18/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit

import FirebaseFunctions
class deleteChannelPopup: UIViewController {

    @IBOutlet weak var popupView: UIView!
    lazy var functions = Functions.functions()
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10
        deleteButton.roundedButton2()
        // Do any additional setup after loading the view.
        //cButton.layer.borderWidth = 1
        //cButton.layer.borderColor = UIColor.lightGray.cgColor

    }

    @IBOutlet weak var cButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteChannel(_ sender: Any) {
        popupView.alpha = 0
        performSegue(withIdentifier: "deleteChannelToLoading", sender: self)

        functions.httpsCallable("deleteChannel").call(["channelName": UserData.currentChannel])
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
            self.dismiss(animated: true){
                            
                self.dismiss(animated: true){
                    self.dismiss(animated: true){
                        
                    }
                }
            }
           
                   print("delete channel worked")
            UserData.currentChannel = "General"
               
        }
        

                     
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

extension UIButton{
    func roundedButton2(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
