
import UIKit
import Firebase
class DetailDetailViewController: UIViewController {

    @IBOutlet weak var AnswerPosterText: UILabel!
    
    @IBOutlet weak var AnswerPosterProfilePicture: UIImageView!
    @IBOutlet weak var AnswerText: UITextView!
    lazy var functions = Functions.functions()
    @IBOutlet weak var AnswerImage: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getAnswer()
        self.AnswerPosterProfilePicture.layer.cornerRadius = self.AnswerPosterProfilePicture.frame.size.width/2
        // Do any additional setup after loading the view.
        
    }
    var answerData:[String:Any] = [:]
    func getAnswer()
    {
        

            let channelname = UserData.currentChannel
            let questionID = UserData.currentQuestion
            let answerID = UserData.currentAnswer
            functions.httpsCallable("getAnswer").call(["channelName": channelname,"questionID":questionID,"answerID":answerID])
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
                    self.AnswerText.text = self.answerData["AnswerText"] as! String
                    self.AnswerPosterText.text = self.answerData["ResponderID"] as! String
                     print(self.AnswerText.text)
                    print("EHREREHREREHR AHHH")
                    print(self.answerData["AnswerText"] as! String)
                      
                  }
            
            let imageID: String = channelname + "-true-" +  questionID + "-true-" + answerID + "-true"
            let storageRef = Storage.storage().reference()
            let photoRef = storageRef.child(imageID)
            
            photoRef.getData(maxSize:  40 * 1024 * 1024)
            {
                (Data, Error)in
                if let err = Error
                {
                    print(err.localizedDescription)
                    self.AnswerImage.image = nil
                    return;
                }
                else
                {
                    print("assigning image")
                    self.AnswerImage.image = UIImage(data: Data!)
                }
            }
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user!.uid
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists
            {
                let dataDictionary = document.data()!
                let picture = dataDictionary["profileImg"] as! String
                self.AnswerPosterProfilePicture.image = UIImage(named: picture)
                self.AnswerPosterProfilePicture.layer.cornerRadius = self.AnswerPosterProfilePicture.frame.size.width / 2
                self.AnswerPosterProfilePicture.clipsToBounds = true
            }
            else
            {
                print("Document does not exist")
            }
        }
            
        }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

    


