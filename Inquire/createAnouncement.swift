//
//  createAnouncement.swift
//  Inquire
//
//  Created by Henry Liu on 8/15/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
class createAnouncement: UIViewController, UITextViewDelegate
{

    lazy var functions = Functions.functions()
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var anouncementText: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10
        anouncementText.delegate = self
        anouncementText.text = "Anouncement Here..."
        anouncementText.textColor = UIColor.lightGray
        anouncementText.layer.borderWidth = 1
        anouncementText.layer.cornerRadius = 10
        
        anouncementText.addinDoneButton(title: 1.0, target: self, selector: #selector(tapDone(sender:)))
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        anouncementText.text = nil
        anouncementText.textColor = UIColor.black
    }
    
    @IBAction func sendAnouncementButton(_ sender: Any)
    {
        //memeopolis
        let channelName = UserData.currentChannel
        let anouncementtext = anouncementText.text!
        let adminName = UserData.currentAdmin
        self.performSegue(withIdentifier: "createAnouncementToLoading", sender: self)
        functions.httpsCallable("createAnouncement").call(["channelName": channelName, "anouncementText": anouncementtext, "adminName": adminName])
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
            
            print("create anouncment worked")
            self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async{
            self.performSegue(withIdentifier: "toCreateAnouncementPopop", sender: self)
            }
            self.anouncementText.text = ""
            //self.dismiss(animated: true, completion: nil)
            print("create anouncment worked")
            
        }
        
        
    }
    
    
    
    
    


    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
 
    
    
}
extension UITextView {
    
    func addinDoneButton(title: Double, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}
