//
//  blockUserList.swift
//  Inquire
//
//  Created by Henry Liu on 9/26/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import Firebase

class blockUserList: UIViewController,UITableViewDelegate, UITableViewDataSource,UITabBarControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if blockedUsers.count > 0
        {
            return 52
        }
        else {
            return 698
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if blockedUsers.count == 0 {
            print("noblockedusers")
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoBlockedUsers", for: indexPath) as! NoBlockedUsersCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockedUserCell", for: indexPath) as! blockedUserCell
            cell.username.text = blockedUsers[indexPath.row]
            
            let db = Firestore.firestore()
            print(indexPath.row)
            print("run")
            print(cell.username.text)
            db.collection("users").whereField("username", isEqualTo: self.blockedUsers[indexPath.row]).getDocuments
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
                        cell.profileImg.image = UIImage(named: picture)
                        cell.profileImg.layer.cornerRadius =
                          cell.profileImg.frame.size.width / 2
                        cell.profileImg.clipsToBounds = true
                      }
                    }
                    else
                    {
                        print("Document does not exist")
                    }
                 }
                     
                 
              }
        
         }
            
            return cell
        
        }

    
    
    
    lazy var refresher : UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    @objc func requestData()
    {
        getBlockedUsers()
        let deadline = DispatchTime.now() + .milliseconds(3000)
        DispatchQueue.main.asyncAfter(deadline: deadline)
        {
            self.refresher.endRefreshing()
        }
        
    }
    
    
    @IBOutlet weak var blockedUserList: UITableView!
    
    override func viewDidLoad() {
        
        print("blockedusershere")
        
        super.viewDidLoad()
        
        blockedUserList.delegate = self
        blockedUserList.dataSource = self
        blockedUserList.refreshControl = refresher
        
        
        getBlockedUsers()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getBlockedUsers()
    }
    
    @IBOutlet weak var blockedUserTableView: UITableView!
    
    var blockedUsers:[String] = []
    
    func getBlockedUsers()
    {
        let db = Firestore.firestore()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "blockedUserToLoading", sender: self)
        }
        db.collection("users").whereField("username", isEqualTo: UserData.currentUser).getDocuments { [self]
            (User, Error) in
            print("result gotten")
            if let error = Error
            {
                print(error.localizedDescription)
            }
            
            for user in User!.documents
            {
                if let blocked = user.data()["BlockedUsers"] as? [String]
                {
                    self.blockedUsers = blocked
                }
                print(self.blockedUsers)
            }
            
            if(self.blockedUsers.count == 0)
            {
                print("got here")
                self.dismiss(animated: true) {
                    DispatchQueue.main.async {
                }
                }
               
            }
            else
            {
                DispatchQueue.main.async {
                    
                self.dismiss(animated: true,completion: nil)
                }
            }
            self.blockedUserList.reloadData()
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    

}
