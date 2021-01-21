//
//  questionImage2.swift
//  Inquire
//
//  Created by Kevin Lu on 1/1/21.
//  Copyright © 2021 Henry Liu. All rights reserved.
//

import UIKit
import Firebase

class questionImage2: UIViewController {

    @IBOutlet weak var questionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let channelname = UserData.currentChannel
            
        let questionID = UserData.currentQuestion
            
        let answerID = UserData.currentAnswer
        
        let imageID: String = channelname + "-true-" +  questionID + "-true-" + answerID + "-true"
        
        let storageRef = Storage.storage().reference()
                    let photoRef = storageRef.child(imageID)
                    photoRef.getData(maxSize:  40 * 1024 * 1024)
                    { (Data, Error) in
                        DispatchQueue.main.async
                            {
                            if let err = Error
                            {
                                print(err.localizedDescription)
                                self.questionImage.image = nil
                                self.questionImage.isUserInteractionEnabled = false
                                print("assigning to be nil")

                            }
                            else
                                {


                                self.questionImage.image = UIImage(data: Data!)

                                }

                            }
                    }
        
    }

    
    @IBAction func dismissButton(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
        
}

