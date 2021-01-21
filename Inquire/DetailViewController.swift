
import UIKit
import Firebase
class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var functions = Functions.functions()
//    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var questionText: UILabel!
    lazy var refresher : UIRefreshControl =
       {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
           return refreshControl
       }()
       @objc func requestData()
       {
            genAnswerList()
           let deadline = DispatchTime.now() + .milliseconds(2000)
           DispatchQueue.main.asyncAfter(deadline: deadline)
           {
               self.searchAnswerTableView.reloadData()
               self.refresher.endRefreshing()
           }
           
       }
    var question = ""
    @IBAction func toShowImage(_ sender: Any)
    {
        UserData.currentQuestion = question
    }
    
    @IBOutlet weak var questionTextHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchAnswerTableView.delegate = self
        searchAnswerTableView.dataSource = self
        searchAnswerTableView.refreshControl  = refresher
        questionText.text = question
        questionText.sizeToFit()
        searchAnswerTableView.rowHeight = UITableView.automaticDimension
//        let fixedWidth = questionText.frame.size.width
//        questionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        /// Get New Size
//        let newSize = questionText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//
//        /// New Frame
//        var newFrame = questionText.frame
//        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//
//        self.questionTextHeightConstraint.constant = CGFloat(min(100,max(Int(newFrame.size.height),Int(40))))
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
            (Timer) in
            self.genAnswerList()
            
            Timer.invalidate()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            print ("load questions intiated")
            self.searchAnswerTableView.reloadData()
            Timer.invalidate()
        }
        
       

    

    }
    func adjustUITextViewHeight(arg : UITextView)
       {
           questionText.sizeToFit()
       }
    override func viewDidAppear(_ animated: Bool)
    {
              super.viewDidAppear(animated)
              Timer.scheduledTimer(withTimeInterval: 1.7, repeats: false) {
                  (Timer) in
                  print("fired")
                  self.searchAnswerTableView.reloadData()
                  Timer.invalidate()
        
              }
        }
    

    @IBOutlet weak var searchAnswerTableView: UITableView!

      
 
            var answerTexts: [String] = []
            var answerPosters: [String] = []
            var answerData: [[String: Any]] = []
            

         
        
            func genAnswerList() {
                let channelName = UserData.currentChannel
                let questionID = question
                UserData.currentQuestion = question
                print(channelName)
                print(questionID)
                UserData.currentQuestion = questionID
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
                    if let questionsList = (result?.data as? [String: Any])?["answerList"] as? [[String:Any]]
                    {
                        //assigning local variable channelsData to channels list
                        self.answerData = questionsList
                        

                    }
                    if(self.answerData.count > 0)
                    {
                        for number in 0...self.answerData.count-1
                        {
                                if  number <= self.answerTexts.count-1
                                {
                                    self.answerTexts[number] = self.answerData[number]["AnswerText"] as! String
                                    self.answerPosters[number] = self.answerData[number]["ResponderID"] as! String
                                }
                                else
                                {
                                    self.answerTexts.append(self.answerData[number]["AnswerText"] as! String)
                                    self.answerPosters.append(self.answerData[number]["ResponderID"] as! String)
                                }
                        }
                    }
                    print(self.answerTexts)

                }
            }
            func numberOfSections(in tableView: UITableView) -> Int {
                return 1
            }
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return answerTexts.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = searchAnswerTableView.dequeueReusableCell(withIdentifier: "searchAnswerCell", for: indexPath) as! searchAnswerCell
                
                cell.AnswerText.text = self.answerTexts[indexPath.row]
    
                return cell
            }
            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                _ = tableView.indexPathForSelectedRow!
                if let _ = tableView.cellForRow(at: indexPath as IndexPath) {
                tableView.deselectRow(at: indexPath, animated: true)
                     UserData.currentAnswer = answerTexts[indexPath.row]
                    self.performSegue(withIdentifier: "toDetailDetail", sender: self)
            }
            
            func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "showdetail" {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let destination = segue.destination as! PastAnswersDetailViewController
                        
                        UserData.currentAnswer = answerTexts[indexPath.row]
                        
                    }
                }
            }
            
        }

        }


