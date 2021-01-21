

import UIKit
import FirebaseFunctions
import FirebaseAuth
import Firebase
import Foundation

protocol Announcements {
    func callSegueFromCell(myData dataobject: AnyObject)
}
protocol ChannelSettings {
    func callSegueFromCellTwo(myData dataobject: AnyObject)
}
protocol LeaveChannel {
    func callSegueFromCellThree(myData dataobject: AnyObject)
}

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Announcements, ChannelSettings, LeaveChannel
{

    func callSegueFromCell(myData dataobject: AnyObject) {
      //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "toAnnouncements", sender:dataobject )

    }
    func callSegueFromCellTwo(myData dataobject: AnyObject) {
      //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "toChannelSettings", sender:dataobject )

    }
    func callSegueFromCellThree(myData dataobject: AnyObject) {
      //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "leaveChannel", sender:dataobject )
    }
    
    @IBOutlet weak var ChannelsTableView: UITableView!
    
        var channelsAdmin: [String] = []
        lazy var refresher : UIRefreshControl =
        {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
            return refreshControl
        }()
        var refreshYes: Bool = false;
        @objc func requestData()
        {
            refreshYes = true
            channelsAdmin = []
            channel = []
            channelsData = []
            getChannelData()
            let deadline = DispatchTime.now() + .milliseconds(3000)
            DispatchQueue.main.asyncAfter(deadline: deadline)
            {
                self.refresher.endRefreshing()
            }
            
        }
        override func viewDidLoad()
        {
            super.viewDidLoad()
                        
            getChannelData()
            
            ChannelsTableView.delegate = self
            ChannelsTableView.dataSource = self
            ChannelsTableView.refreshControl = refresher
            
            self.performSegue(withIdentifier: "channelsToLoading", sender: self)
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true)
                { timer in
                        print("timer fired!")
                    self.ChannelsTableView.reloadData()
                        if self.channelsData.count > 0
                        {
                            self.dismiss(animated: true, completion: nil)
                            timer.invalidate()
                        }
                    self.counter+=1
                    print(self.counter)
                               if self.counter >= 150
                               {
                                
                                   self.dismiss(animated: true)
                                   {
                                     self.performSegue(withIdentifier: "channelsToNoData", sender: self)
                                    }
                                timer.invalidate()
                               }
                }
        }
        //COLLECTION VIEW
        //COLLECTION VIEW
        //COLLECTION VIEW
        //COLLECTION VIEW
        lazy var functions = Functions.functions()
        var channelsData:[[String:Any]] = [];
        var channel: [String] = []
        var counter = 0
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            channelsAdmin = []
            channel = []
            channelsData = []
            getChannelData()
            //self.performSegue(withIdentifier: "channelsToLoading", sender: self)
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true)
                { timer in
                        print("timer fired!")
                        if self.channelsData.count > 0
                        {
                            self.dismiss(animated: true, completion: nil)
                            
                            timer.invalidate()
                        }
                    self.counter+=1
                               if self.counter == 16
                               {
                                   //self.dismiss(animated: true)
                                   //{
                                    //}
                                        timer.invalidate()
                               }
                }
            
        }
        
        override func didReceiveMemoryWarning()
        {
            super.didReceiveMemoryWarning()
        }
        let cellSpacingHeight:CGFloat = 5
       
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 10
        }
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
            headerView.backgroundColor = UIColor.white
            return headerView
        }

        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return channel.count*2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            if indexPath.row % 2 == 0
            {
                print("cell")
                print(indexPath.row)
                let cell = ChannelsTableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelTableViewCell
                cell.delagete = self
                cell.dalegete = self
                cell.dg = self
                if channelsAdmin.count > 0
                {
                    cell.primaryAdminName.text = channelsAdmin[indexPath.item/2]
                }
                cell.channelName.text = channel[indexPath.item/2]
                /*
                if channel[indexPath.item/2] == "General"
                {
                    print("this ran2")
                    cell.leaveChannel.alpha = 0
                    cell.leaveChannel.isUserInteractionEnabled = false
                }
                */
                cell.layer.cornerRadius = cell.layer.frame.height / 10
                //cell.channelImage.image = channelImages[indexPath.item/2]
                
                if indexPath.row % 5 == 0
                {
                    cell.backgroundColor = UIColor(red: 62/255, green: 80/255, blue: 114/255, alpha: 1.0)
                    //(red: 173/255, green: 216/255, blue: 231/255, alpha: 1.0)
                }
                else if indexPath.row % 5 == 1
                {
                    cell.backgroundColor = UIColor(red: 85/255, green: 34/255, blue: 44/255, alpha: 1.0)
                }
                else if indexPath.row % 5 == 2
                {
                    cell.backgroundColor = UIColor(red: 71/255, green: 98/255, blue: 87/255, alpha: 1.0)
                }
                else if indexPath.row % 5 == 3
                {
                    cell.backgroundColor = UIColor(red: 214/255, green: 227/255, blue: 108/255, alpha: 1.0)
                }
                else
                {
                    cell.backgroundColor = UIColor(red: 168, green: 98, blue: 204, alpha: 1.0)
                }
                
                
                return cell
                
            }
            else if indexPath.row % 2 == 1
            {
                print("space")
                print(indexPath.row)
                let spacerCell = ChannelsTableView.dequeueReusableCell(withIdentifier: "spacerCell", for: indexPath)
                spacerCell.backgroundColor = UIColor.white
                
                spacerCell.isUserInteractionEnabled = false
                return spacerCell
            }
            return UITableViewCell()
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             if indexPath.row % 2 == 1
             {
                return 10
                
              }
            else
             {
                return 200
            }
        }
        var selectedChannel = ""
        
        //PERFORM SEGUE TO SECOND VIEW CONTROLLER
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
        //let cell = ChannelsTableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as! ChannelTableViewCell
           selectedChannel = channel[indexPath.item/2]
            UserData.currentChannel = selectedChannel
            //ChannelsTableView.deselectRow(at: indexPath, animated: true)
            self.tabBarController?.selectedIndex = 0;
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            if(segue.identifier == "TapToQuestions")
            {
                var vc = segue.destination as! ViewQuestionViewController
                if selectedChannel != ""
                {
                    vc.currentChannelName = selectedChannel;
                }
            }
            
        }

        
        func getChannelData()
        {
            print ("envoked")
            
            // generate channel data for a single userID
            let uid = UserData.currentUser
            print(uid)
            
            functions.httpsCallable("genChannelList").call(["userID": uid])
            {
                (result, error) in
                
                //results in the form of an array of json objects
                if let channelList = (result?.data as? [String: Any])?["channelList"] as? [[String:Any]]
                {
                    //assigning local variable channelsData to channels list
                    self.channelsData = channelList
                }
                if(self.channelsData.count > 0 )
                {
                    for number in 0...self.channelsData.count-1
                   {
                        if number > self.channel.count-1
                        {
                            self.channel.append( self.channelsData[number]["channelName"] as! String)
                            self.channelsAdmin.append( self.channelsData[number]["admin"] as! String)
                        }
                        else
                        {
                            self.channel[number] = self.channelsData[number]["channelName"] as! String
                            self.channelsAdmin[number] = self.channelsData[number]["admin"] as! String
                        }
                    }
                }
                self.ChannelsTableView.reloadData()
            }
        
        
        }
    
    
        @IBAction func backFromModal(_ segue: UIStoryboardSegue)
             {
                var vc = segue.destination as! ViewQuestionViewController
                if selectedChannel != ""
                {
                    vc.currentChannelName = selectedChannel;
                }
                self.tabBarController?.selectedIndex = 2
             }
    }

    /*extension ChannelViewController: DeleteRowInTableviewDelegate {
        func deleteRow(inTableview rowToDelete: Int) {
            let selectedCell = channel[rowToDelete]
            delete(selectedCell)
            ChannelsTableView.reloadData()
        }*/
