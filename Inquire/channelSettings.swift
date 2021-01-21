//
//  channelSettings.swift
//  Inquire
//
//  Created by Henry Liu on 8/15/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
class channelSettings: UIViewController,UITableViewDelegate,UITableViewDataSource
{
   

    @IBOutlet weak var ChannelBio: UITextView!
    var channelName = UserData.currentChannel

    @IBOutlet weak var channelCode: UILabel!
    @IBOutlet var ChannelName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var userTableView: UITableView!
    lazy var functions = Functions.functions()
    lazy var refresher : UIRefreshControl =
       {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
           return refreshControl
       }()
       var isRefresh = false
       @objc func requestData()
       {
           isRefresh = true
           getChannel()
           let deadline = DispatchTime.now() + .milliseconds(3000)
           DispatchQueue.main.asyncAfter(deadline: deadline)
           {
               self.refresher.endRefreshing()
           }
           
       }
    var isAppear = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("ran333")
        channelName = UserData.currentChannel
        getChannel()
        self.deleteButton.alpha = 0
        self.deleteButton.isUserInteractionEnabled = false
        //self.channelCode.alpha = 0
        userTableView.delegate = self
        userTableView.dataSource = self
        ChannelName.text = channelName

        
        userTableView.refreshControl = refresher
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false)
        { (Timer) in
            print("fired")
            if self.channelAdmin == UserData.currentUser
            {
                self.deleteButton.alpha = 1
                self.deleteButton.isUserInteractionEnabled = true
                self.channelCode.alpha = 1
            }
            self.userTableView.reloadData()
            Timer.invalidate()
        }
        

    }
    override func viewDidAppear(_ animated: Bool) {
        

        
        super.viewDidAppear(animated)
        channelName = UserData.currentChannel
        print("ran222")
        isAppear = true
        getChannel()
        self.deleteButton.alpha = 0
        self.deleteButton.isUserInteractionEnabled = false
        //self.channelCode.alpha = 0
        userTableView.delegate = self
        userTableView.dataSource = self
        ChannelName.text = channelName

        
         
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false)
        { (Timer) in
            print("fired")
            if self.channelAdmin == UserData.currentUser
            {
                self.deleteButton.alpha = 1
                self.deleteButton.isUserInteractionEnabled = true
                self.channelCode.alpha = 1
            }
            self.userTableView.reloadData()
            Timer.invalidate()
        }
        

    }
    var channelAdmin = ""
    var channelsData:[String:Any] = [:];
    var users:[String] = []
    func getChannel()
    {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "channelSettingsToLoading", sender: self)
        }
        
        print("dib")
        print(UserData.currentChannel)
        functions.httpsCallable("getChannel").call(["channelName": channelName])
        { [self]
            (result, error) in
            if let error = error as NSError?
            {
                if error.domain == FunctionsErrorDomain
                {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
                self.dismiss(animated: true, completion: nil)
            }
            //results in the form of an array of json objects
            if let channel = (result?.data as? [String: Any])?["channelData"] as? [String:Any]
            {
                //assigning local variable channelsData to channels list
                self.channelsData = channel
            }
            let code = self.channelsData["ChannelCode"] as! String
            self.channelCode.text = "Channel Code: " + code
            self.users = self.channelsData["Users"] as! [String]
            self.channelAdmin = self.channelsData["Admin"] as! String
            print(self.channelsData["ChannelBio"] as! String)
            self.ChannelBio.text = self.channelsData["ChannelBio"] as! String
            if (code == "")
            {
                self.channelCode.text = "none"
            }
            self.dismiss(animated: true, completion: nil)
            
            self.userTableView.reloadData()
            print("users")
            print(self.users)
            self.isAppear = false
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if channelAdmin == UserData.currentUser
        {
            
            let username = UserData.currentUser
            functions.httpsCallable("leaveChannel").call(["userName": users[indexPath.row], "channelID":UserData.currentChannel])
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
                        print("left")
            }
            if editingStyle == .delete
            {

                        // remove the item from the data model
                        users.remove(at: indexPath.row)

                        // delete the table view row
                        userTableView.deleteRows(at: [indexPath], with: .fade)

            }
            print("herehjj")
        }
        
        
        
        
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        if channelAdmin == UserData.currentUser
        {
            return UITableViewCell.EditingStyle.delete
        }
        else{
            
            return UITableViewCell.EditingStyle.none
        }
        
        
    }
    
              
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print("here")
        let cell = userTableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as! UserCell
        cell.username.text = users[indexPath.row]
        
        let db = Firestore.firestore()
        db.collection("users").whereField("username", isEqualTo: users[indexPath.row]).getDocuments
            {
                (QuerySnapshot, Error) in
                if let err = Error
                {
                    print(err.localizedDescription)
                }
                for document in QuerySnapshot!.documents
                {
                   if document.exists
                   {
                    let dataDictionary = document.data()
                       let picture = dataDictionary["profileImg"] as! String
                       cell.userProfilePicture.image = UIImage(named: picture)
                       cell.userProfilePicture.layer.cornerRadius = cell.userProfilePicture.frame.size.width / 2
                       cell.userProfilePicture.clipsToBounds = true
                   }
                   else
                   {
                       print("Document does not exist")
                   }
                }
        }
        //cell.kickButton.alpha = 0
        //cell.kickButton.layer.borderWidth = 1
        //cell.kickButton.layer.cornerRadius = 10
        //cell.kickButton.layer.borderColor = UIColor.lightGray.cgColor
        cell.channelAdmin = channelAdmin
       //cell.kickButton.isUserInteractionEnabled = false
        if (channelAdmin == UserData.currentUser)
        {
            //cell.kickButton.alpha = 1
            //cell.kickButton.isUserInteractionEnabled = true
                
        }
        return cell

        
        
    }
    
    
              
    @IBAction func deleteChannel(_ sender: Any)
    {
        
        UserData.currentChannel = channelName
    }
    
    

}
