import UIKit
import Firebase

protocol toPastAnswerPopup {
func callSegueToPastAnswerPopup(myData dataobject: AnyObject)
}

protocol toPastReplyPopup {
func callSegueToPastReplyPopup(myData dataobject: AnyObject)
}

/*class CellClass2: UITableViewCell {
    
}*/


class MyPastQuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate, toPastAnswerPopup, toPastReplyPopup {
    
    func callSegueToPastReplyPopup(myData dataobject: AnyObject) {
        self.performSegue(withIdentifier: "toDeleteReplyPopup", sender: dataobject)
    }
    
    func callSegueToPastAnswerPopup(myData dataobject: AnyObject) {
        self.performSegue(withIdentifier: "toDeleteAnswerPopup", sender: dataobject)
    }
    
    /*func callSegueToDeleteQuestionPopup(myData dataobject: AnyObject) {
        self.performSegue(withIdentifier: "toDeleteQuestionPopup", sender: dataobject)
    }*/
    
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var viewQuestionImage: UIButton!
    @IBOutlet weak var questionLine: UILabel!
    @IBOutlet weak var pastContentTableView: UITableView!
    
    /*let thisTableView = UITableView()

    
    var dataSource = [String] ()

    let transparentView = UIView()
    
    var selectedButton = UIButton()

    
    @IBAction func onClick(_ sender: Any) {
        print("clicked the click")
        dataSource = ["Delete"]
        self.selectedButton = self.dropDown
        self.addTransparentView(frames: self.dropDown.frame)
    }
    
     func addTransparentView(frames: CGRect)
     {
         
      let window = UIApplication.shared.keyWindow
      transparentView.frame = window?.frame ?? self.view.frame
      self.view.addSubview(transparentView)
      
      thisTableView.frame = CGRect(x: frames.origin.x - 130, y: frames.origin.y + frames.height, width: 170, height: 0)
      self.view.addSubview(thisTableView)
      
      thisTableView.reloadData()
      
      let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
      transparentView.addGestureRecognizer(tapgesture)
      transparentView.alpha = 0
      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
          self.transparentView.alpha = 0.5
        self.thisTableView.frame = CGRect(x: frames.origin.x - 130, y: frames.origin.y + frames.height + 5, width: 170, height: CGFloat(self.dataSource.count * 50))
      })
      {
          (bool) in
          print(bool)
          print("dfse")
      }
      
      }
      
      @objc func removeTransparentView()
      {
          let frames = selectedButton.frame
          UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                    self.transparentView.alpha = 0
               self.thisTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
              self.view.willRemoveSubview(self.transparentView)
                }, completion: nil)
          
      }
      
      func tableView2 (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          print("dueh")
          return 2
       }
    
    
      func tableView2 (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("here")
        let CellClass2 = self.thisTableView.dequeueReusableCell(withIdentifier: "CellClass2", for: indexPath) as! CellClass2
        print("for table view")
        dataSource = ["Delete"]
        CellClass2.textLabel?.text = dataSource[indexPath.row]
        return CellClass2
      }
      
      
      func tableView2 (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 50
      }
      
      
    func tableView2 (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        if indexPath.row == 0
        {
        
            print("row 0")
            callSegueToDeleteQuestionPopup(myData: self)
        }

        removeTransparentView()
    }*/
    

    @IBOutlet weak var deleteQuestionButton: UIButton!
    
    @IBAction func deleteQuestion(_ sender: Any) {
        
        performSegue(withIdentifier: "toDeleteQuestionPopup", sender: self)
        
    }
    
    @IBAction func viewQuestionImageTapped(_ sender: Any) {
    }
    

    lazy var refresher : UIRefreshControl =
           {
               let refreshControl = UIRefreshControl()
               refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
               return refreshControl
           }()
           @objc func requestData()
           {
            answerTexts = []
            answerPosters = []
            answerData = []
            answerLikes = []
            answerReplies = []
            answerTimes = []
            answerOrder = []
            replyCreationTimes = []
            replierIDs = []
            replieTexts = []
            answerTextsStorage = []
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
                (Timer) in
                self.genAnswerList()
                Timer.invalidate()
            }
               let deadline = DispatchTime.now() + .milliseconds(2000)
               DispatchQueue.main.asyncAfter(deadline: deadline)
               {
                   self.pastContentTableView.reloadData()
                   self.refresher.endRefreshing()
               }
               
           }
        
        lazy var functions = Functions.functions()
        
        override func viewDidLoad()
        {
           super.viewDidLoad()
            self.question.alpha = 0
            self.viewQuestionImage.alpha = 0
            self.pastContentTableView.alpha = 0
            self.questionLine.alpha = 0
            self.deleteQuestionButton.alpha = 0
            self.navigationController?.isNavigationBarHidden = true
           navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Past Question", style: .plain, target: self, action: #selector(ProfileButtonTapped))

            print("past answers done")
            self.tabBarController?.delegate = self
            pastContentTableView.delegate = self
            pastContentTableView.dataSource = self
            pastContentTableView.refreshControl = refresher
            answerTexts = []
            answerPosters = []
            answerData = []
            answerLikes = []
            answerReplies = []
            answerTimes = []
            answerOrder = []
            replyCreationTimes = []
            replierIDs = []
            replieTexts = []
            answerTextsStorage = []
            self.genAnswerList()
            pastContentTableView.estimatedRowHeight = 600
            pastContentTableView.rowHeight = UITableView.automaticDimension
            pastContentTableView.frame = CGRect(x: pastContentTableView.frame.origin.x, y: pastContentTableView.frame.origin.y, width: pastContentTableView.contentSize.width, height: pastContentTableView.contentSize.height)
                        
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.question.alpha = 0
            self.viewQuestionImage.alpha = 0
            self.pastContentTableView.alpha = 0
            self.questionLine.alpha = 0
            self.deleteQuestionButton.alpha = 0
            self.navigationController?.isNavigationBarHidden = true

             navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Past Question", style: .plain, target: self, action: #selector(ProfileButtonTapped))
            
            print("past answers done")
            answerTexts = []
            answerPosters = []
            answerData = []
            answerLikes = []
            answerReplies = []
            answerTimes = []
            answerOrder = []
            replyCreationTimes = []
            replierIDs = []
            replieTexts = []
            answerTextsStorage = []
            pastContentTableView.reloadData()
            genAnswerList()
        }
    
    @objc func ProfileButtonTapped() {
     print("Button Tapped")
     performSegue(withIdentifier: "toProfile", sender: self)
    
    }
    
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toProfile"
            {
            let vc = segue.destination as! ProfileViewController
                
                print(vc)
                
                /*vc.questionsButton.alpha = 0
                vc.answersButton.alpha = 0
                vc.profileImg.alpha = 0
                vc.rankingImg.alpha = 0
                vc.username.alpha = 0
                vc.logOutButton.alpha = 0
                vc.points.alpha = 0
                vc.profileView.alpha = 0
                vc.profileTableView.alpha = 0*/
        }
    }
    
        var answerTexts: [String] = []
        var answerPosters: [String] = []
        var answerData: [[String: Any]] = []
        var answerLikes:[Int] = []
        var answerReplies:[Int] = []
        var answerTimes:[String] = []
        var answerOrder:[String] = []
        var replyCreationTimes:[String] = []
        var replierIDs:[String] = []
        var replieTexts:[String] = []
        var answerTextsStorage:[String] = []
        var questionData:[String: Any] = [:]
        
   
    
        func genAnswerList()
        {
            self.performSegue(withIdentifier: "pastQuestionsToLoading", sender: self)
                        
            self.noDataOn = true
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short

            print("invoked")
            let channelName = UserData.currentChannel
            let questionID = UserData.currentQuestion
            print(questionID)
            print(channelName)
            print("printing")
            functions.httpsCallable("genAnswerList").call(["channelName": channelName,"questionID":questionID,"userName":UserData.currentUser])
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
                if let answerList = (result?.data as? [String: Any])?["answerList"] as? [[String:Any]]
                {
                    //assigning local variable channelsData to channels list
                    self.answerData = answerList
                }
                if(self.answerData.count > 0)
                {
                    self.answerTexts = []
                    self.answerPosters = []
                    self.answerLikes = []
                    self.answerReplies = []
                    self.answerTimes = []
                    self.answerOrder = []
                    self.replyCreationTimes = []
                    self.replierIDs = []
                    self.replieTexts = []
                    self.answerTextsStorage = []
                    
                    self.answerOrder.removeAll()
                    print("begin")
                    for number in 0...self.answerData.count-1
                    {
                            let creationTime = self.answerData[number]["CreationTime"] as! [String: Double]
                            let seconds = creationTime["_seconds"]! + pow(creationTime["_nanoseconds"] as! Double, -9.0)
                            let creationDate = NSDate(timeIntervalSince1970: seconds)
                            let creationDateString = formatter.string(from: creationDate as Date)
                                self.answerTexts.append(self.answerData[number]["AnswerText"] as! String)
                                self.answerTextsStorage.append(self.answerData[number]["AnswerText"] as! String)
                                self.answerPosters.append(self.answerData[number]["ResponderID"] as! String)
                                if((self.answerData[number]["Replies"] as! [Any]).count != 0)
                                {
                                    self.answerReplies.append((self.answerData[number]["Replies"] as! [Any]).count)
                                }
                                else
                                {
                                    self.answerReplies.append(0)
                                }
                                self.answerTimes.append(creationDateString)
                        
                        self.answerOrder.append("Answer")
                        print(self.answerTexts[number])
                        if(self.answerReplies[number]>0)
                        {
                            //for every reply in the replies array in an answer
                            for numbers in 0...self.answerReplies[number]-1
                            {
                                self.answerOrder.append("Reply")
                                let Reply = (self.answerData[number]["Replies"] as! [Any])[numbers] as! [String:Any]
                                let replyCreationTime = Reply["CreationTime"] as! [String: Double]
                                let seconds = replyCreationTime["_seconds"] as! Double+pow(replyCreationTime["_nanoseconds"] as! Double, -9.0)
                                let replyCreationDate = NSDate(timeIntervalSince1970: seconds)
                                let replyCreationDateString = formatter.string(from: replyCreationDate as Date)
                                self.replieTexts.append(Reply["ReplieText"] as! String)
                                print(Reply["ReplieText"] as! String)
                                self.replyCreationTimes.append(replyCreationDateString)
                                self.replierIDs.append(Reply["ReplierID"] as! String)
                            }
                            
                            
                        }
                      
                    }
                    
                    
                
                    
                    
                   
                }
                else{
                    self.noDataOn = true
                    
                }
                self.question.alpha = 1
                self.viewQuestionImage.alpha = 1
                self.pastContentTableView.alpha = 1
                self.questionLine.alpha = 1
                self.deleteQuestionButton.alpha = 1
                self.navigationController?.isNavigationBarHidden = false
                self.pastContentTableView.reloadData()
                
                self.dismiss(animated: true)
                               
            }
            print(channelName)
            print(questionID)
            print("expl")
            functions.httpsCallable("getQuestion").call(["channelName": channelName,"questionID":questionID])
                  {
                      (results, error) in
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
                      if let questionD = (results?.data as? [String: Any])?["questionData"] as? [String:Any]
                      {
                          //assigning local variable channelsData to channels list
                          self.questionData = questionD
                      }
                    print("iggy biggy")
                    print(self.questionData)
                    print("end")
                     print(self.questionData["QuestionText"] as! String)
                    self.question.text = "Q: " + (self.questionData["QuestionText"] as! String)
                    
                    if self.questionData["QuestionPoster"] as! String != UserData.currentUser {
                        self.deleteQuestionButton.alpha = 0
                    }
                  }
            
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("the count")
            print(answerOrder.count)
            if(answerOrder.count == 0)
            {
                return 1
            }
            return answerOrder.count

        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            
            print("runny")
            if answerData.count == 0 {
                let cell = pastContentTableView.dequeueReusableCell(withIdentifier: "noContentCell4", for: indexPath) as! noContentCell4
            print("gotme")
                return cell

            }
               
            else if(answerData.count > 0 && answerOrder[indexPath.row] == "Answer")
                {
                   
                    let Answercell = pastContentTableView.dequeueReusableCell(withIdentifier: "myPastAnswer", for: indexPath) as! MyPastAnswerTableViewCell
     
                    
                    Answercell.toPAP = self
                    Answercell.toPAR = self
                                       
                    if(answerPosters.count > 0)
                    {
                        
                        let db = Firestore.firestore()
                        
                        db.collection("users").whereField("username", isEqualTo: self.answerPosters[0]).getDocuments
                            {
                                (QuerySnapshot, Error) in
                                    DispatchQueue.main.async{
                                        if let err = Error
                                        {
                                            print(err.localizedDescription)
                                        }
                                        for document in QuerySnapshot!.documents
                                        {
                                            if document.exists
                                            {
                                                if Error == nil
                                                {
                                                    let dataDictionary = document.data()
                                                    let picture = dataDictionary["profileImg"] as! String
                                            Answercell.pfp.image = UIImage(named: picture)
                                            Answercell.pfp.layer.cornerRadius =
                                            Answercell.pfp.frame.size.width / 2
                                            Answercell.pfp.clipsToBounds = true
                                                }
                                            }
                                            else
                                            {
                                                print("Document does not exist")
                                            }
                                        }
                                               
                                           
                                    }
                                           
                            }
                    
                        Answercell.username.text = nil
                        Answercell.answer.text = nil
                        Answercell.dateTime.text = nil
                        
                        DispatchQueue.main.async{
                        Answercell.username.text = self.answerPosters[0]
                        Answercell.answer.text = self.answerTexts[0]
                        Answercell.dateTime.text = self.answerTimes[0]
                        //Answercell.pfp.image = 

                                self.answerReplies.remove(at: 0)
                                self.answerPosters.remove(at: 0)
                                self.answerTexts.remove(at: 0)
                                self.answerTimes.remove(at: 0)
                            
                        }
                        
                        return Answercell

                    }
                    return Answercell

                }
                else //if answerOrder[indexPath.row] == "Reply"
                {
                    let replyCell = pastContentTableView.dequeueReusableCell(withIdentifier: "MyPastComments", for: indexPath) as! MyPastCommentTableViewCell
                    if replieTexts.count > 0
                    {
                            print("lol")
                            print( self.replieTexts[0])
                        replyCell.comment.text = nil
                        replyCell.dateTime.text = nil
                        replyCell.username.text = nil
                        DispatchQueue.main.async{
                            replyCell.comment.text = self.replieTexts[0]
                            replyCell.dateTime.text = self.replyCreationTimes[0]
                            replyCell.username.text = self.replierIDs[0]
                            let db = Firestore.firestore()
                            
                            db.collection("users").whereField("username", isEqualTo: self.replierIDs[0]).getDocuments
                                {
                                    (QuerySnapshot, Error) in
                                        //DispatchQueue.main.async{
                                            if let err = Error
                                            {
                                                print(err.localizedDescription)
                                            }
                                            for document in QuerySnapshot!.documents
                                            {
                                                if document.exists
                                                {
                                                    if Error == nil
                                                    {
                                                        let dataDictionary = document.data()
                                                        let picture = dataDictionary["profileImg"] as! String
                                                replyCell.pfp.image = UIImage(named: picture)
                                                replyCell.pfp.layer.cornerRadius =
                                                replyCell.pfp.frame.size.width / 2
                                                replyCell.pfp.clipsToBounds = true
                                                    }
                                                }
                                                else
                                                {
                                                    print("Document does not exist")
                                                } 
                                            }
                                                   
                                               
                                        //}
                            }
                            self.replieTexts.remove(at: 0)
                            self.replyCreationTimes.remove(at: 0)
                            self.replierIDs.remove(at: 0)
                        }
                        
                        return replyCell
                    }
                    return replyCell

                    
                }
            
        
        
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if answerOrder.count > 0
                //&& answerOrder[indexPath.row] == "Reply"
            {
                return UITableView.automaticDimension
            }
            /*else if answerOrder.count > 0 && answerOrder[indexPath.row] == "Reply"
            {
                return UITableView.automaticDimension
            }*/
            else {
                return 698
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            pastContentTableView.deselectRow(at: indexPath, animated: true)
            print("herdfe")
            print(answerOrder)
            print(indexPath.row)
            print("selected")
            if(answerOrder.count == 0)
            {
            return
            }
                if answerOrder[indexPath.row] == "Answer"
                {
                    var answer = 0
                    for number in 0...indexPath.row
                    {
                        if answerOrder[number] == "Answer"
                        {
                            answer+=1
                        }
                    }
                    print("herejj")
                    UserData.currentAnswer = answerTextsStorage[answer-1]
                    
                    
                }
        }
        

        @IBAction func toAnswers(_ segue: UIStoryboardSegue)
        {
                       
        self.tabBarController?.selectedIndex = 0
            
        }
        
        var noDataOn = false
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                let tabBarIndex = tabBarController.selectedIndex
                print("rayayan")
                print("tab bar index")
                print(tabBarIndex)
                if tabBarIndex != 0 && noDataOn
                {
                    dismiss(animated:true, completion:nil)
                    noDataOn = false
                }
        }
        override func viewWillDisappear(_ animated: Bool) {
            UserData.returningToViewQuestion = true
        }
         
        
    }

