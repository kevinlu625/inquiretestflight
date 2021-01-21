

import UIKit
import FirebaseFunctions
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarControllerDelegate {
    
    var questionArray: [String] = []
    
    var currentChannelName = UserData.currentChannel
    
    var questionData: [[String: Any]] = []
        
    var searchingQuestions = [String()]
    
    var searching = false
    
    lazy var functions = Functions.functions()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingQuestions.count
            
        } else {
            return questionArray.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching
        {
            cell?.textLabel?.text = searchingQuestions[indexPath.row]
        }
        else
        {
            cell?.textLabel?.text = questionArray[indexPath.row]
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        if searching && searchChannels.count > 0 
        {
            
            vc?.question = searchingQuestions[indexPath.row]
            UserData.currentChannel = searchChannels[indexPath.row]
            print( searchingQuestions[indexPath.row])
            print(searchChannels[indexPath.row])
            print("I AM HERE")
        }
        else
        {
            vc?.question = questionArray[indexPath.row]
            UserData.currentChannel = questionChannel[indexPath.row]
        }
        
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    lazy var refresher : UIRefreshControl =
       {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
           return refreshControl
       }()
       @objc func requestData()
       {
           getQuestionData()
           let deadline = DispatchTime.now() + .milliseconds(2000)
           DispatchQueue.main.asyncAfter(deadline: deadline)
           {
               self.refresher.endRefreshing()
           }
           
       }

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    getQuestionData()
        tableView.refreshControl = refresher
        searchBar.addingDonButton(title: 1.0, target: self, selector: #selector(tapDone(sender:)))

    }
        
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.tabBarController?.delegate = self
            getQuestionData()
        }
    
    var searchChannels:[String] = []
    func searchBar(_ searchBar:  UISearchBar, textDidChange searchText: String) {
        
        searchingQuestions = []
        searchChannels = []
        if(questionArray.count != 0)
        {
            
        
            if searchText == ""
            {
                searchingQuestions = questionArray
            }
            else
            {
                for number in 0...questionArray.count-1
                {
                    if questionArray[number].lowercased().contains(searchText.lowercased())
                    {
                        searchChannels.append(questionChannel[number])
                        searchingQuestions.append(questionArray[number])
                    }
                }
                /*
                for question in questionArray {
                    if question.lowercased().contains(searchText.lowercased()) {
                        searchingQuestions.append(question)
                    }
     
                }
                 */
            }
        
            //searchingQuestions = questionArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
            searching = true
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }

var questionChannel:[String] = []
func getQuestionData()
{
    let username = UserData.currentUser
    functions.httpsCallable("genAllQuestions").call(["userName": username])
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
        if let questionsList = (result?.data as? [String: Any])?["questionList"] as? [[String:Any]]
        {
            
            //assigning local variable channelsData to channels list
            self.questionData = questionsList
        }
        
        if(self.questionData.count > 0)
        {
            for number in 0...self.questionData.count-1
            {
                if  number <= self.questionArray.count-1
                {
                   self.questionArray[number] = self.questionData[number]["QuestionText"] as! String
                    self.questionChannel[number] = self.questionData[number]["ChannelName"] as! String
                }
                else
                {
                    self.questionArray.append(self.questionData[number]["QuestionText"] as! String)
                    self.questionChannel.append( self.questionData[number]["ChannelName"] as! String)
                }
            }
        }
        self.tableView.reloadData()

    }
    
}
    
    @objc func tapDone(sender: Any) {
           self.view.endEditing(true)
       }
}

    
    

extension UISearchBar {
    
    func addingDonButton(title: Double, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}




