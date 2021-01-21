//
//  showQuestionImagePopup.swift
//  Inquire
//
//  Created by Henry Liu on 8/18/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseStorage
class showQuestionImagePopup: UIViewController {

    @IBOutlet weak var questionImage: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("here")
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            
        
        let imageID: String = UserData.currentChannel + "-true-" + UserData.currentQuestion + "-true"
        //pull image
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child(imageID)
        print(photoRef.name)
            print(imageID)
        print("here34")
            photoRef.getData(maxSize:  40 * 1024 * 1024)
            { (Data, Error)
                in
                if let err = Error
                {
                    print(err.localizedDescription)
                    self.questionImage.image = nil
                    
                }
                else
                {
                    print("assigning dsf")
                    self.questionImage.image = UIImage(data: Data!)
                }
            }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            if self.questionImage.image == nil
            {
                self.performSegue(withIdentifier: "showImageToNoData", sender: self)
            }
            
        }
            timer.invalidate()
        }

    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
