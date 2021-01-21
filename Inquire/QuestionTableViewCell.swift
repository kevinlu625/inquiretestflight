
import UIKit
import FirebaseFunctions
class CelllClass: UITableViewCell {
    
}


class QuestionTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var pastAnswersButton: UIButton!
    @IBOutlet weak var channelName: UILabel!
    lazy var functions = Functions.functions()
    
    override func awakeFromNib()
    {
        
        super.awakeFromNib()
        if questionImage.image == nil
        {
        }
        thisTableView.delegate = self
        thisTableView.dataSource = self
        thisTableView.register(CelllClass.self, forCellReuseIdentifier: "Cell")
        print("ran")
    }
    
    @IBOutlet weak var btnChannel: UIButton!
    @IBAction func onClick(_ sender: Any) {
        
            print("clicked")
            dataSource = ["Flag","Block User"]
            self.selectedButton = self.btnChannel
            self.addTransparentView(frames: self.btnChannel.frame)
            print("doned")
        
       
    }
    
    let thisTableView = UITableView()
        
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    let transparentView = UIView()
    
   func addTransparentView(frames: CGRect)
   {
       
    let window = UIApplication.shared.keyWindow
    transparentView.frame = window?.frame ?? self.contentView.frame
    self.contentView.addSubview(transparentView)
    
    thisTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
    self.contentView.addSubview(thisTableView)
    
    //transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
    thisTableView.reloadData()
    
    let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
    transparentView.addGestureRecognizer(tapgesture)
    transparentView.alpha = 0
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
        self.transparentView.alpha = 0.5
        self.thisTableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
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
            self.contentView.willRemoveSubview(self.transparentView)
              }, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("dueh")
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("here")
        let cell = self.thisTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CelllClass
        print("for table view")
        
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        if indexPath.row == 0
        {
            print("row 0")
            flagQuestion()
        }
        else
        {
            print("row 1")
            blockUser()
        }

        removeTransparentView()
    }
    
    
    @IBAction func toPastAnwersButton(_ sender: Any)
    {
        print("fire")
        UserData.currentChannel = channelName.text!
        UserData.currentQuestion = question.text!
    }
    
    
    @IBAction func answerTapped(_ sender: Any) {
        UserData.currentQuestion = question.text!
        UserData.currentChannel = channelName.text!
        
    }
    
     func flagQuestion()
     {
        let flagger = UserData.currentUser
        let channelID = channelName.text!
        let questionID = question.text!
        functions.httpsCallable("flagQuestion").call(["flagger":flagger,"channelID":channelID,"questionID":questionID])
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
            print("flagged")
        }

    }
    
    func blockUser()
    {
        let flagger = UserData.currentUser
        
        let blocked = username.text!
        if(flagger != blocked)
        {
            functions.httpsCallable("blockUser").call(["blocker":flagger,"blocked":blocked])
            { (HTTPSCallableResult, Error) in
                if let error = Error as NSError?
                {
                    if error.domain == FunctionsErrorDomain
                    {
                            let code = FunctionsErrorCode(rawValue: error.code)
                            let message = error.localizedDescription
                            let details = error.userInfo[FunctionsErrorDetailsKey]
                            print(message)
                    }
                }
                print("blocked")

                
            }
        }
        
        
    }
    
    
    
}
