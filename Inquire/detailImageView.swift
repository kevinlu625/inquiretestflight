//
//  detailImageView.swift
//  Inquire
//
//  Created by Henry Liu on 8/17/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseStorage
class detailImageView: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageID: String = UserData.currentChannel + "-true-" + UserData.currentQuestion + "-true"
        //pull image
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child(imageID)
        print(photoRef.name)
            print(imageID)
            photoRef.getData(maxSize: 40 * 1024 * 1024)
            { (Data, Error)
                in
                if let err = Error
                {
                    print(err.localizedDescription)
                    self.questionImage.image = nil
                    return;
                }
                else
                {
                    print("assigning image")
                    self.questionImage.image = UIImage(data: Data!)
                }
            }
        
       
    }
    

    @IBAction func cancelView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var questionImage: UIImageView!
    
    
}
