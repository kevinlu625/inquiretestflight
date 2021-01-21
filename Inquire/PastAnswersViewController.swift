import UIKit
import Firebase

class PastAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    @IBOutlet weak var pastAnswersTableView: UITableView!
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var viewQuestionImage: UIButton!
    @IBOutlet weak var divider: UILabel!
    
    var contentSize = 0
    var tableSize = 0
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
               self.pastAnswersTableView.reloadData()
               self.refresher.endRefreshing()
           }
           
       }
    
    lazy var functions = Functions.functions()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.pastAnswersTableView.alpha = 0
        self.question.alpha = 0
        self.viewQuestionImage.alpha = 0
        self.divider.alpha = 0
        self.navigationController?.isNavigationBarHidden = true
        self.genAnswerList()
        print("past answers done")
        self.tabBarController?.delegate = self
        pastAnswersTableView.delegate = self
        pastAnswersTableView.dataSource = self
        pastAnswersTableView.refreshControl = refresher
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
        
        pastAnswersTableView.estimatedRowHeight = 600
        pastAnswersTableView.rowHeight = UITableView.automaticDimension
        pastAnswersTableView.frame = CGRect(x: pastAnswersTableView.frame.origin.x, y: pastAnswersTableView.frame.origin.y, width: pastAnswersTableView.frame.size.width, height: pastAnswersTableView.contentSize.height);
        
        
//        pastAnswersTableView.estimatedRowHeight = 1000
//
//        pastAnswersTableView.rowHeight = UITableView.automaticDimension

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        pastAnswersTableView.reloadData()
        genAnswerList()
        
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
        
        self.performSegue(withIdentifier: "pastAnswersToLoading", sender: self)
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        print("invoked")
        let channelName = UserData.currentChannel
        let questionID = UserData.currentQuestion
        print(questionID)
        print(channelName)
        print("printing")
        functions.httpsCallable("getQuestion").call(["channelName": channelName,"questionID":questionID])
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
            if let questionD = (result?.data as? [String: Any])?["questionData"] as? [String:Any]
            {
                //assigning local variable channelsData to channels list
                self.questionData = questionD
            }
          self.question.text = "Q: " + (self.questionData["QuestionText"] as! String)
          let contentSize = self.question.sizeThatFits(self.question.bounds.size)
          print("contentSize")
          print(contentSize.height)

        
            self.functions.httpsCallable("genAnswerList").call(["channelName": channelName,"questionID":questionID,"userName":UserData.currentUser])
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
                self.pastAnswersTableView.reloadData()
                self.pastAnswersTableView.estimatedRowHeight = 600
                self.pastAnswersTableView.rowHeight = UITableView.automaticDimension
                self.pastAnswersTableView.alpha = 1
                self.question.alpha = 1
                self.viewQuestionImage.alpha = 1
                self.divider.alpha = 1
                self.navigationController?.isNavigationBarHidden = false
                self.dismiss(animated: true)
            
            } else {
                              
                self.pastAnswersTableView.alpha = 1
                self.question.alpha = 1
                self.viewQuestionImage.alpha = 1
                self.divider.alpha = 1
                self.navigationController?.isNavigationBarHidden = false
                self.dismiss(animated: true)
                
                self.noDataOn = true
            }
        }
        
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(answerOrder.count == 0)
        {
            return 1
        }
        return answerOrder.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(indexPath.row)

        if answerData.count == 0 {

                let cell = tableView.dequeueReusableCell(withIdentifier: "noContentCell2", for: indexPath)as! noContentCell2
                
                return cell
        }
        
        if(answerData.count > 0 && answerOrder[indexPath.row] == "Answer" )
            {
                
                let Answercell = tableView.dequeueReusableCell(withIdentifier: "Answers", for: indexPath) as! PastAnswersTableViewCell
               
                if(answerPosters.count > 0)
                {
                    Answercell.username.text = nil
                    Answercell.Answer.text = nil
                    Answercell.AnsweredTime.text = nil
                    
                    print("lol")
                    print(self.answerTexts[0])
                    
                    Answercell.username.text = self.answerPosters[0]
                    Answercell.Answer.text = self.answerTexts[0]
                    Answercell.AnsweredTime.text = self.answerTimes[0]

                    Firestore.firestore().collection("users").whereField("username", isEqualTo:self.answerPosters[0]).getDocuments
                    {
                        (QuerySnapshot, Error) in
                        //DispatchQueue.main.async{
                            if let err = Error
                            {
                                print(err.localizedDescription)
                            }
                            for document in QuerySnapshot!.documents
                            {
                                if document.exists && Error == nil
                                {
                                    let dataDictionary = document.data()
                                    let picture = dataDictionary["profileImg"] as! String
                                    Answercell.pfp.image = UIImage(named: picture)
                                    Answercell.pfp.layer.cornerRadius = Answercell.pfp.frame.size.width / 2
                                    Answercell.pfp.clipsToBounds = true
                                }
                                    
                            }
                        
                        
                    }
                        
                    self.answerReplies.remove(at: 0)
                    self.answerPosters.remove(at: 0)
                    self.answerTexts.remove(at: 0)
                    self.answerTimes.remove(at: 0)
                    let tableSize = pastAnswersTableView.frame.origin.y
                    print("tableSize")
                    print(tableSize)
                    return Answercell

                }
                let tableSize = pastAnswersTableView.frame.origin.y
                print("tableSize")
                print(tableSize)
                return Answercell

            }
            else //if answerOrder[indexPath.row] == "Reply"
            {
                let replyCell = tableView.dequeueReusableCell(withIdentifier: "Reply", for: indexPath) as! CommentTableViewCell
                if replieTexts.count > 0
                {
                        print("lol")
                        print( self.replieTexts[0])
                    replyCell.comment.text = nil
                    replyCell.Timestamp.text = nil
                    replyCell.User.text = nil
                    
                        replyCell.comment.text = self.replieTexts[0]
                        replyCell.Timestamp.text = self.replyCreationTimes[0]
                        replyCell.User.text = self.replierIDs[0]
                    Firestore.firestore().collection("users").whereField("username", isEqualTo:self.replierIDs[0]).getDocuments
                                       {
                                           (QuerySnapshot, Error) in
                                           //DispatchQueue.main.async{
                                               if let err = Error
                                               {
                                                   print(err.localizedDescription)
                                               }
                                               for document in QuerySnapshot!.documents
                                               {
                                                   if document.exists && Error == nil{
                                                           let dataDictionary = document.data()
                                                           let picture = dataDictionary["profileImg"] as! String
                                                       replyCell.pfp.image = UIImage(named: picture)
                                                       replyCell.pfp.layer.cornerRadius = replyCell.pfp.frame.size.width / 2
                                                       replyCell.pfp.clipsToBounds = true
                                                       }
                                                       
                                                   }
                                               }
                                           
                                       
                        self.replieTexts.remove(at: 0)
                        self.replyCreationTimes.remove(at: 0)
                        self.replierIDs.remove(at: 0)
                    
               
                    return replyCell
                }
                let tableSize = pastAnswersTableView.frame.origin.y
                print("tableSize")
                print(tableSize)
                return replyCell

                
            }
        
    
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if answerOrder.count > 0
        {

            return UITableView.automaticDimension
        }
        else
        {
            return 698
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        pastAnswersTableView.deselectRow(at: indexPath, animated: true)
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
                print("here2jj")
                //self.performSegue(withIdentifier: "showdetail", sender: self)
                print("here3jj")
                
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

    
    
    
  


