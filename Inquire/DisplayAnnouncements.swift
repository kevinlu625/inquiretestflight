import UIKit
import FirebaseFunctions

class DisplayAnnouncements: UIViewController,UITableViewDelegate, UITableViewDataSource
{
        
    @IBOutlet weak var anouncementTableView: UITableView!
    
    lazy var functions = Functions.functions()


    lazy var refresher : UIRefreshControl =
       {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
           return refreshControl
       }()
       @objc func requestData()
       {
         genAnouncementList()
           let deadline = DispatchTime.now() + .milliseconds(2000)
           DispatchQueue.main.asyncAfter(deadline: deadline)
           {
               self.anouncementTableView.reloadData()
               self.refresher.endRefreshing()
           }
           
       }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        anouncementTableView.alpha = 0
        self.navigationController?.isNavigationBarHidden = true
        
        genAnouncementList()
        anouncementTableView.refreshControl = refresher
        anouncementTableView.delegate = self
        anouncementTableView.dataSource = self
        anouncementTableView.estimatedRowHeight = 600
        anouncementTableView.rowHeight = UITableView.automaticDimension

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        anouncementTableView.alpha = 0
        self.navigationController?.isNavigationBarHidden = true
        genAnouncementList()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if anouncementTexts.count == 0 {
            return 1
        } else {
            return anouncementTexts.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     print("marker")
     print(anouncementData)
     if anouncementData.count == 0
        {
     let noDatacell = anouncementTableView.dequeueReusableCell(withIdentifier: "noContentCell3", for: indexPath) as! noContentCell3
        print(noDatacell)
    print("check check")
        return noDatacell
        } else
        {
            let cell = anouncementTableView.dequeueReusableCell(withIdentifier: "anouncementCell", for: indexPath) as! DisplayAnouncementCell
            cell.AnouncementText.text = anouncementTexts[indexPath.row]
            cell.AnouncementTime.text = anouncementTimes[indexPath.row]
            cell.AnouncementChannel.text = anouncementChannels[indexPath.row]
            
            return cell
            
        }
        print("all")
        
    }
    
    var anouncementData:[[String:Any]] = []
    var anouncementTexts:[String] = []
    var anouncementTimes:[String] = []
    var anouncementChannels:[String] = []
    var anouncementAdmins:[String] = []
    func genAnouncementList()
    {
        self.performSegue(withIdentifier: "anouncementsToLoading", sender: self)
    
        
        let username = UserData.currentUser
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
 
        functions.httpsCallable("genUserAnouncements").call(["userName": username])
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
                //results  the form of an array of json objects
            if let anouncementsList = (result?.data as? [String: Any])?["anouncementList"] as? [[String:Any]]
            {
                self.anouncementData = anouncementsList

            }
            if (self.anouncementData.count > 0)
            {
                for number in 0...self.anouncementData.count-1
                {
                    let creationTime = self.anouncementData[number]["CreationTime"] as! [String: Double]
                    let seconds = creationTime["_seconds"] as! Double+pow(creationTime["_nanoseconds"] as! Double, -9.0)
                    let creationDate = NSDate(timeIntervalSince1970: seconds)
                    let creationDateString = formatter.string(from: creationDate as Date)
                    if number <= self.anouncementTexts.count-1
                    {
                         self.anouncementTexts[number] = self.anouncementData[number]["AnouncementText"]  as! String
                         self.anouncementTimes[number] = creationDateString
                         self.anouncementChannels[number] =  self.anouncementData[number]["ChannelName"] as! String
                         self.anouncementAdmins[number] = self.anouncementData[number]["Admin"] as! String
                    }
                    else
                    {
                        self.anouncementTexts.append(self.anouncementData[number]["AnouncementText"]  as! String)
                        self.anouncementTimes.append( creationDateString)
                        self.anouncementChannels.append(self.anouncementData[number]["ChannelName"] as! String)
                        self.anouncementAdmins.append(self.anouncementData[number]["Admin"] as! String)
                    }
                    
                }
                
                self.anouncementTableView.alpha = 1
                self.navigationController?.isNavigationBarHidden = false
                
                self.dismiss(animated: true, completion: nil)
            }
            else {
                
                self.anouncementTableView.alpha = 1
                self.navigationController?.isNavigationBarHidden = false
                
                // NO DATA HERE DELETE BELOW
                self.dismiss(animated: true)
                {

                }
                // no content here
            }
            
            self.anouncementTableView.reloadData()
            
        }
        
        
    }


}
