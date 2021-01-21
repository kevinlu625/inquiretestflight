import UIKit
import Firebase
import FirebaseFunctions
import FirebaseAuth
import FirebaseStorage
import Photos

class AnswerQuestion: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate
{
    var currentChannelName = UserData.currentChannel
    var currentQuestionID = UserData.currentQuestion
    lazy var functions = Functions.functions()

    @IBOutlet weak var viewImage: UIButton!
    
    @IBOutlet weak var AnswerText: UITextView!
    
    @IBOutlet weak var questionText: UITextView!
    
    @IBOutlet weak var questionLine: UIImageView!
    
    
    func resizeTextViewFrame()
    {
        questionText?.delegate = self
        
        let fixedWidth = questionText?.frame.size.width
        
        let newSize: CGSize = questionText!.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat(MAXFLOAT)))
        
        var newFrame = questionText!.frame
        
        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth!))), height: newSize.height)
        
        questionText!.frame = newFrame
    }

    @IBOutlet weak var submitAnswerButton: UIButton!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    override func viewDidLoad()
    {
        self.viewImage.alpha = 0
        self.AnswerText.alpha = 0
        self.questionText.alpha = 0
        self.questionLine.alpha = 0
        self.uploadImageButton.alpha = 0
        self.submitAnswerButton.alpha = 0
        super.viewDidLoad()
        print(currentChannelName)
        print(currentQuestionID)
        print("current")
        AnswerText.delegate = self
        AnswerText.textColor = UIColor.lightGray
        AnswerText.text = "Write answer here"
        AnswerText.layer.borderWidth = 1
        AnswerText.layer.borderColor = UIColor.lightGray.cgColor
        imagePicker.delegate = self
        AnswerText.layer.cornerRadius = 10
        uploadImageButton.layer.cornerRadius = 10
        submitAnswerButton.layer.cornerRadius = 10
        questionText.layer.cornerRadius = 10
        answerImageLabel.text = nil
        questionText.isScrollEnabled = false
//        textViewDidChange(questionText)
        adjustUITextViewHeight(arg: questionText)
        /*
        questionImage.layer.borderWidth = 0.1
        questionImage.layer.borderColor = UIColor.lightGray.cgColor
        questionImage.layer.cornerRadius = 10
         */
        self.AnswerText.additionDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))

        getQuestion()
        
        answerImageLabel.alpha = 0
        deleteImageButton.alpha = 0
        imageLine1.alpha = 0
        imageLine2.alpha = 0
    }
    func textViewDidChange(_ textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        let fixedWidth = textView.frame.size.width
          textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
          var newFrame = textView.frame
          newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
          textView.frame = newFrame
    }
    func adjustUITextViewHeight(arg : UITextView)
    {
        questionText.sizeToFit()
        questionText.isScrollEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewImage.alpha = 0
        self.AnswerText.alpha = 0
        self.questionText.alpha = 0
        self.questionLine.alpha = 0
        self.uploadImageButton.alpha = 0
        self.submitAnswerButton.alpha = 0

        self.url = nil
        self.answerImageLabel.text = ""
    }
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var url:URL? = nil
    var questionTextstore = ""
    @IBOutlet weak var answerImageLabel: UILabel!
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var imageLine1: UILabel!
    
    @IBOutlet weak var imageLine2: UILabel!
    
    @IBAction func deleteImage(_ sender: Any) {
        answerImageLabel.alpha = 0
        deleteImageButton.alpha = 0
        imageLine1.alpha = 0
        imageLine2.alpha = 0
    }
    
    @IBAction func UploadImageButton(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
           {
               imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)

           }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
               self.url = info[UIImagePickerController.InfoKey.imageURL] as? URL
                
                   print(url)
            answerImageLabel.text = url?.absoluteString
            answerImageLabel.alpha = 1
            deleteImageButton.alpha = 1
            imageLine1.alpha = 1
            imageLine2.alpha = 1
            
               let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
               //postImageView.image = image
               imagePicker.dismiss(animated: true, completion: nil)
    }

    func uploadToCloud(fileURL:URL,_ answerText: String)
           {
               let storageRef = Storage.storage().reference()

               let data = Data()
            let imageID =  UserData.currentChannel + "-true-" + UserData.currentQuestion + "-true-" + answerText + "-true"
               print(imageID)
               
               let photoRef = storageRef.child(imageID)

               let uploadTask = photoRef.putFile(from: fileURL, metadata: nil)
               {
                   (metadata, error) in
                    self.url = nil
                       guard let metadata = metadata else
                       {
                           print(error?.localizedDescription)
                           return
                       }

               }
            print("image uploaded" + imageID)

        }

    @IBAction func SubmitButton(_ sender: Any)
    {
        
        answerImageLabel.alpha = 0
        deleteImageButton.alpha = 0
        imageLine1.alpha = 0
        imageLine2.alpha = 0
        
        //submit an answer
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user!.uid

        let docRef = db.collection("users").document(uid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDictionary = document.data()!
                let fullName = dataDictionary["username"] as! String
                let picture = dataDictionary["profileImg"] as! String
                /*let curr_points = dataDictionary["Points"] as! String
                var updated_points = Int(curr_points)
                updated_points = updated_points! + 1
                
                let stringPoints = "\(updated_points)"*/
                
                UserData.currentUser = fullName
                /*db.collection("users").document(uid).updateData(["points":stringPoints])
                { (Error) in
            
                }*/
         
            } else {
                print("Document does not exist")
            }
        }
        
        let channelname = currentChannelName
        let questionID = currentQuestionID
        let answererID = UserData.currentUser
        print("add answer invoked")
        print(channelname)
        print(questionID)
        print(answererID)
        print(currentQuestionID)
        sentChannel = channelname
        self.performSegue(withIdentifier: "AnswerToLoading", sender: self)
        var answerText = AnswerText.text!
        answerText.censor()
        functions.httpsCallable("addAnswer").call(
            ["channelName":channelname,"questionID":UserData.currentQuestion,"responderID":answererID,"answerText":answerText])
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
            if self.url != nil
            {
                self.uploadToCloud(fileURL: self.url!, self.AnswerText.text!)
            }
            self.AnswerText.text = ""
            self.answerImageLabel.text = ""
            self.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async
            {
                self.performSegue(withIdentifier: "answerQuestionToPopup", sender: self)
                    
            }
            print("add answer worked")
        }
}
    
    @IBAction func viewImage(_ sender: Any) {
        UserData.currentChannel = currentChannelName
        UserData.currentQuestion = currentQuestionID
    }
    
    var sentChannel = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
      {
        if segue.identifier == "answerQuestionToPopup"
        {
          var vc = segue.destination as! AnswerQuestionPopup
            vc.channelName = sentChannel
        }
      }
    
    
    
    var question:[String:Any] = [:];
    var questionPoster = ""
    var questiontext = ""
    func getQuestion()
    {
        let channelname = UserData.currentChannel
        let questionID = UserData.currentQuestion
        print(channelname)
        print(questionID)
        print("dfaf")
        functions.httpsCallable("getQuestion").call(["channelName": channelname,"questionID":questionID])
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
                  if let questionData = (result?.data as? [String: Any])?["questionData"] as? [String:Any]
                  {
                      //assigning local variable channelsData to channels list
                      self.question = questionData
                  }
                
                self.questionText.text = "Q: " + (self.question["QuestionText"] as! String)
                self.viewImage.alpha = 1
                self.AnswerText.alpha = 1
                self.questionText.alpha = 1
                self.questionLine.alpha = 1
                self.uploadImageButton.alpha = 1
                self.submitAnswerButton.alpha = 1
                  
              }
        
        /*let imageID: String = channelname + "-true-" +  questionID + "-true"
        let storageRef = Storage.storage().reference()
        let photoRef = storageRef.child(imageID)
        photoRef.getData(maxSize:  40 * 1024 * 1024)
        {
            (Data, Error)in
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
        }*/
      
        
        
          
    }
        var counter = 0
    func textViewDidBeginEditing(_ AnswerText: UITextView)
    {
            if counter < 1
            {
                AnswerText.text = ""
           AnswerText.textColor = UIColor.black
            counter += 1
        }
    }
        
    /*@IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        if questionImage?.image != nil
        {
        let imageView:UIImageView? = sender.view as! UIImageView
        
            let newImageView = UIImageView(image: imageView!.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden
        }
    }*/
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
          self.navigationController?.isNavigationBarHidden = false
          self.tabBarController?.tabBar.isHidden = false
          sender.view?.removeFromSuperview()
      }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserData.returningToViewQuestion = true
    }
}

extension UITextView {
    
    func additionDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: "done", style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}

    
        
        
    
    
    



