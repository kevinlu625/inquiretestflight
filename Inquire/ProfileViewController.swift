
import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {

    @IBOutlet weak var profileTableView: UITableView!
    
    // Connect these
 
    @IBOutlet weak var questionsButton: UIButton!
    
    @IBOutlet weak var answersButton: UIButton!

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var rankingImg: UIImageView!

    @IBOutlet var username: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var points: UILabel!
    
    lazy var functions = Functions.functions()
    
        var questionTexts: [String] = []
        var questionPosters: [String] = []
        var questionTimes: [String] = []
        var questionChannels: [String] = []
        var questionAnswerNumbers: [String] = []
        var userData: [[String: Any]] = []
        var noDataOn = false
    
        var answerCount  = -1

        var currentPFP = ""
        // edit
        var rank = ""
        
        var status = "question"
        var nodata_status = false
    
        let noDataImage = UIImage(named: "nodata.jpg")
        let myImageView:UIImageView = UIImageView()
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        lazy var refresher : UIRefreshControl =
           {
               let refreshControl = UIRefreshControl()
               refreshControl.addTarget(self, action: #selector(requestingData), for: .valueChanged)
               return refreshControl
           }()
           @objc func requestingData()
           {
            
            genUserData()
            
               let deadline = DispatchTime.now() + .milliseconds(2000)
               DispatchQueue.main.asyncAfter(deadline: deadline)
               {
                   self.refresher.endRefreshing()
               }
               
           }
    
        func addNoContent() {
            view.addSubview(myView)
            view.addSubview(myImageView)
        }
        
        func removeNoContent() {
            myView.removeFromSuperview()
            myImageView.removeFromSuperview()
        }
        
    @IBOutlet weak var profileView: UIView!
    
        override func viewDidLoad() {
            print("viewdidload")
            super.viewDidLoad()
            self.questionsButton.alpha = 0
            self.answersButton.alpha = 0
            self.profileImg.alpha = 0
            self.rankingImg.alpha = 0
            self.username.alpha = 0
            self.logOutButton.alpha = 0
            self.points.alpha = 0
            self.profileView.alpha = 0
            self.profileTableView.alpha = 0
            var recognizer = UITapGestureRecognizer(target: self, action: #selector(pfpSelector(_:)))
            self.profileImg.isUserInteractionEnabled = true

            self.profileImg.addGestureRecognizer(recognizer)
            
            nodata_status = false
            setUpElements()
            self.navigationController?.isNavigationBarHidden = true
            super.viewDidLoad()
            genUserData()
            self.tabBarController?.delegate = self
            profileTableView.refreshControl = refresher
            profileTableView.delegate = self
            profileTableView.dataSource = self
            // need none image to be same color image as background color (basically invisable)
            myView.backgroundColor = .white

            myImageView.contentMode = UIView.ContentMode.scaleAspectFit
            myImageView.frame.size.width = UIScreen.main.bounds.width
            myImageView.frame.size.height = UIScreen.main.bounds.height
            myImageView.center = self.view.center
            myImageView.image = noDataImage
            
            // Do any additional setup after loading the view.
        }
    
    
        
        override func viewDidAppear(_ animated: Bool) {
            print("viewdidappear")
            
            super.viewDidAppear(animated)
            self.questionsButton.alpha = 0
            self.answersButton.alpha = 0
            self.profileImg.alpha = 0
            self.rankingImg.alpha = 0
            self.username.alpha = 0
            self.logOutButton.alpha = 0
            self.points.alpha = 0
            self.profileView.alpha = 0
            self.profileTableView.alpha = 0
            self.navigationController?.isNavigationBarHidden = true
            print("this runs")
            genUserData()
            rankingImg.alpha = 0
            //nodata_status  == false
            
            
            if rank == "first" {
                rankingImg.alpha = 1

                rankingImg.image = UIImage(named:"first")

            } else if rank == "second" {
                rankingImg.alpha = 1

                rankingImg.image = UIImage(named:"second")
            } else if rank == "third" {
                rankingImg.alpha = 1

                rankingImg.image = UIImage(named:"third")
            }
            
            
                print("this runs")
                print(UserData.justChangedPFP )
                print(UserData.currentPFP)
                if UserData.justChangedPFP && UserData.currentPFP != ""
                {
                    
                    self.profileImg.image = UIImage(named: UserData.currentPFP)
                    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
                    self.profileImg.clipsToBounds = true
                    UserData.justChangedPFP = false
                    UserData.currentPFP = ""
                    
                }
                else
                {
                    self.setUpElements()
                }
            
        }
    
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer)
    {

        let tap = UITapGestureRecognizer(target: self, action: #selector(pfpSelector))
      
    }
    
    @objc func pfpSelector(_ sender: UITapGestureRecognizer) {
       print("meme")
       self.performSegue(withIdentifier:"toPFP", sender: self)
    }
        
        @IBAction func didTapQuestions(_ sender: Any) {
            questionsButton.setTitleColor(UIColor.systemBlue, for: .normal)
            answersButton.setTitleColor(UIColor.lightGray, for: .normal)
            
            //if noDataOn == true {
              //  removeNoContent()
            //}
            
            status = "question"
            nodata_status = false
            genUserData2()
            
            
        }

        @IBAction func didTapAnswers(_ sender: Any) {
            questionsButton.setTitleColor(UIColor.lightGray, for: .normal)
            answersButton.setTitleColor(UIColor.systemBlue, for: .normal)
            
           // if noDataOn == true {
             //   removeNoContent()
            //}
            
            status = "answer"
            nodata_status = false
            genUserData2()
            

        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if status == "answer" {
               
                return 100
                
            } else {
                
                return 80
            }
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if nodata_status == true {
                return 1
            } else {
                if status == "answer" {
                    return answerData.count
                } else {
                    return questionData.count
                }
            }
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if nodata_status == true {
                //CHANGE
                let cell = tableView.dequeueReusableCell(withIdentifier: "noContent", for: indexPath) as! noContentCell
                return cell
                
            } else {
                if status == "answer" {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "profilePastAnswersCell", for: indexPath) as! pastAnswersCell
                    
                    let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .short
                    
                    let creationTime = self.answerData[indexPath.row]["CreationTime"] as! [String: Double]
                    let seconds = creationTime["_seconds"] as! Double+pow(creationTime["_nanoseconds"] as! Double, -9.0)
                    let creationDate = NSDate(timeIntervalSince1970: seconds)
                    let creationDateString = formatter.string(from: creationDate as Date)
                    let answerTexts = self.answerData[indexPath.row]["AnswerText"] as! String
                    let answerPosters = self.answerData[indexPath.row]["ResponderID"] as! String
                    let answerChannel = self.answerData[indexPath.row]["ChannelName"] as! String
                    let questionID = self.answerData[indexPath.row]["QuestionID"] as! String
                    
                    // assign variables to table view cell
                    
                    //cell.channelName.text = answerChannel
                    cell.dateTime.text = creationDateString
                    //cell.question.text =
                    cell.answer.text = "A: "+answerTexts
                    //cell.counter.
                    cell.channelName.text = answerChannel
                    cell.question.text = "Q: "+questionID
                    
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "profilePastQuestionsCell", for: indexPath) as! pastQuestionsCell
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .short
                    
                    let creationTime = self.questionData[indexPath.row]["CreationTime"] as! [String: Double]
                    let seconds = creationTime["_seconds"] as! Double+pow(creationTime["_nanoseconds"] as! Double, -9.0)
                    let creationDate = NSDate(timeIntervalSince1970: seconds)
                    let creationDateString = formatter.string(from: creationDate as Date)
                    let questionTexts = self.questionData[indexPath.row]["QuestionText"] as! String
                    let questionPosters = self.questionData[indexPath.row]["QuestionPoster"] as! String
                    let questionChannel = self.questionData[indexPath.row]["ChannelName"] as! String

                    // assign var
                    
                    cell.channelName.text = questionChannel
                    cell.dateTime.text = creationDateString
                    cell.question.text = "Q: " + questionTexts
                    cell.counter.text = String(self.questionData[indexPath.row]["AnswerNumber"] as! Int)
                    
                    return cell
            }
    
            }
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
            if nodata_status == true {
                
            } else {
                if status == "answer" {
                    
                    profileTableView.deselectRow(at: indexPath, animated: true)
                    
                    UserData.currentChannel = self.answerData[indexPath.row]["ChannelName"] as! String
                    UserData.currentQuestion = self.answerData[indexPath.row]["QuestionID"] as! String
                    UserData.currentAnswer = self.answerData[indexPath.row]["AnswerText"] as! String

                
                    
                } else {
                    profileTableView.deselectRow(at: indexPath, animated: true)

                    UserData.currentChannel = self.questionData[indexPath.row]["ChannelName"] as! String
                    UserData.currentQuestion = self.questionData[indexPath.row]["QuestionText"] as! String
                    
                    //print("segue2")
                //performSegue(withIdentifier: "toAnswers", sender: self)
                }
            }
            
        }
        
        var questionData:[[String:Any]] = []
        var answerData:[[String:Any]] = []
        
        
        func genUserData()
        {
            
        self.performSegue(withIdentifier:"profileToLoading", sender: self)

            questionData = []
            answerData = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short

            let userID = UserData.currentUser
            print(userID)
            print("here is the user id")
            functions.httpsCallable("genUserQuestions").call(["userName": userID])
            { (Res, err) in
                if let err = err as NSError?
                {
                    if err.domain == FunctionsErrorDomain
                    {
                        _ = err.localizedDescription
                        _ = err.userInfo[FunctionsErrorDetailsKey]
                    }
                }

                if let questionsdb = (Res?.data as? [String: Any])?["questionList"] as? [[String: Any]]
                {
    
                    self.questionData = questionsdb
                }
               
                if self.questionData.count == 0 && self.status == "question" {
                    self.nodata_status = true
                }
                else
                {
                    self.nodata_status = false
                }
                
                let user1 = Auth.auth().currentUser
                let uid = user1!.uid
                print("questions gotten")
                self.functions.httpsCallable("genUserAnswers").call(["uid": uid]) { (Result, error) in
                    print("doneee")
                    if let errors = error as NSError?
                    {
                        if errors.domain == FunctionsErrorDomain
                        {
                            _ = errors.localizedDescription
                            _ = errors.userInfo[FunctionsErrorDetailsKey]
                        }
                    }
                    if let answersdb = (Result?.data as? [String: Any])?["answerList"] as? [[String: Any]]
                    {
                        self.answerData = answersdb
                        print("answe rs gotten")
                        print(self.answerData)
                        
                    }
                    
                    if self.answerData.count == 0 && self.status == "answer" {
                        self.nodata_status = true
                    }
                    
                    self.questionsButton.alpha = 1
                    self.answersButton.alpha = 1
                    self.profileImg.alpha = 1
                    self.rankingImg.alpha = 1
                    self.username.alpha = 1
                    self.logOutButton.alpha = 1
                    self.points.alpha = 1
                    self.profileView.alpha = 1
                    self.profileTableView.alpha = 1
                    self.profileTableView.reloadData()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    
    func genUserData2()
    {
        

        questionData = []
        answerData = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        let userID = UserData.currentUser
        print(userID)
        print("here is the user id")
        functions.httpsCallable("genUserQuestions").call(["userName": userID])
        { (Res, err) in
            if let err = err as NSError?
            {
                if err.domain == FunctionsErrorDomain
                {
                    _ = err.localizedDescription
                    _ = err.userInfo[FunctionsErrorDetailsKey]
                }
            }

            if let questionsdb = (Res?.data as? [String: Any])?["questionList"] as? [[String: Any]]
            {

                self.questionData = questionsdb
            }
           
            if self.questionData.count == 0 && self.status == "question" {
                self.nodata_status = true
            }
            else
            {
                self.nodata_status = false
            }
            
            let user1 = Auth.auth().currentUser
            let uid = user1!.uid
            print("questions gotten")
            self.functions.httpsCallable("genUserAnswers").call(["uid": uid]) { (Result, error) in
                print("doneee")
                if let errors = error as NSError?
                {
                    if errors.domain == FunctionsErrorDomain
                    {
                        _ = errors.localizedDescription
                        _ = errors.userInfo[FunctionsErrorDetailsKey]
                    }
                }
                if let answersdb = (Result?.data as? [String: Any])?["answerList"] as? [[String: Any]]
                {
                    self.answerData = answersdb
                    print("answe rs gotten")
                    print(self.answerData)
                    
                }
                
                if self.answerData.count == 0 && self.status == "answer" {
                    self.nodata_status = true
                }
                
                self.questionsButton.alpha = 1
                self.answersButton.alpha = 1
                self.profileImg.alpha = 1
                self.rankingImg.alpha = 1
                self.username.alpha = 1
                self.logOutButton.alpha = 1
                self.points.alpha = 1
                self.profileView.alpha = 1
                self.profileTableView.alpha = 1
                self.profileTableView.reloadData()
            }
        }
    }
    
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            let tabBarIndex = tabBarController.selectedIndex
            print("rayayan")
            if tabBarIndex != 4 && noDataOn
            {
                dismiss(animated:true, completion:nil)
                noDataOn = false
            }
        }
        
        func setUpElements() {

            let db = Firestore.firestore()
            let user = Auth.auth().currentUser
            let uid = user!.uid

            let docRef = db.collection("users").document(uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDictionary = document.data()!
                    let fullName = dataDictionary["username"] as! String
                    let picture = dataDictionary["profileImg"] as! String
                    let points = dataDictionary["Points"] as! Int
                    UserData.currentUser = fullName
                    self.points.text = " \(points)" + " points"
                    self.username.text = fullName
                    self.profileImg.image = UIImage(named: picture)
                    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
                    self.profileImg.clipsToBounds = true
                    
                } else {
                    print("Document does not exist")
                }
            }

        }

        func transitionToStart() {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "startStoryBoard")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }

        @IBAction func logOutButtonTapped(_ sender: Any) {
            
            GIDSignIn.sharedInstance()?.signOut()
            
            let auth = Auth.auth()
            do {
                try auth.signOut()
                transitionToStart()

            } catch let signOutError as Error {
                self.present(Utilities.createAlertController(title: "Error", message: signOutError.localizedDescription), animated: true, completion: nil)
            }

        }
           
    @objc func requestData()
           {
            answerData = []
            questionData=[]
           self.profileTableView.reloadData()
           self.genUserData()
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false)
            {
                (Timer) in
                self.profileTableView.reloadData()
                self.refresher.endRefreshing()
                Timer.invalidate()
            }

               
           }

        
        
        @IBAction func backFromModal(_ segue: UIStoryboardSegue) {

            self.tabBarController?.selectedIndex = 1
        }
        
        @IBAction func backtoProfile(_ segue: UIStoryboardSegue)
             {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (Timer) in
                    
                
               print("thidfs runs")
                      print(UserData.justChangedPFP )
                      print(UserData.currentPFP)
                      if UserData.justChangedPFP && UserData.currentPFP != ""
                      {
                          
                          self.profileImg.image = UIImage(named: UserData.currentPFP)
                          self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2
                          self.profileImg.clipsToBounds = true
                          UserData.justChangedPFP = false
                          UserData.currentPFP = ""
                          
                      }
                    Timer.invalidate()
                }
             }

    }
