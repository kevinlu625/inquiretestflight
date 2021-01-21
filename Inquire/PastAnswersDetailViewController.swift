//
//  PastAnswersDetailViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 7/24/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import UIKit
import Firebase
class PastAnswersDetailViewController: UIViewController {
    lazy var functions = Functions.functions()
    
    @IBOutlet weak var answerImage: UIImageView!
    
    override func viewDidLoad()
    {
        print("here")
        super.viewDidLoad()
        getAnswer()
        
    }
    var answerData:[String:Any] = [:]
    func getAnswer()
    {
        let channelname = UserData.currentChannel
        let questionID = UserData.currentQuestion
        let answerID = UserData.currentAnswer

        /*functions.httpsCallable("getAnswer").call(["channelName": channelname,"questionID":questionID,"answerID":answerID])
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
                  //results in the form of an array of json objects
                  if let answersData = (result?.data as? [String: Any])?["answerData"] as? [String:Any]
                  {
                      //assigning local variable channelsData to channels list
                      self.answerData = answersData
                  }
                self.answer.text = self.answerData["AnswerText"] as! String
                self.username.text = self.answerData["ResponderID"] as! String
              }*/
        
        let imageID: String = channelname + "-true-" +  questionID + "-true-" + answerID + "-true"
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child(imageID)
        
        print("ooga booga")
        print(imageID)
        
        photoRef.getData(maxSize: 40 * 1024 * 1024)
        {
            (Data, Error)in
            if let err = Error
            {
                print(err.localizedDescription)
                self.answerImage.image = nil
                return;
            }
            else
            {
                print("assigning image")
                self.answerImage.image = UIImage(data: Data!)
            }
        }
        let db = Firestore.firestore()
        /*let docRef = db.collection("users").whereField("username", isEqualTo: username.text).getDocuments
        {
            (QuerySnapshot, Error) in
            if let err = Error
            {
                print(err.localizedDescription)
            }
            for document in QuerySnapshot!.documents
            {
               if document.exists
               {
                let dataDictionary = document.data()
                let picture = dataDictionary["profileImg"] as! String
                self.profilePicture.image = UIImage(named: picture)
                self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
                self.profilePicture.clipsToBounds = true
               }
               else
               {
                   print("Document does not exist")
               }
            }
        }*/
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    
      
}

