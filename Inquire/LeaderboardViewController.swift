//
//  LeaderboardViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 12/25/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions
import Firebase

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var functions = Functions.functions()
    
    var username: [String] = []
    var points: [Int] = []
    var rank: [Int] = []
    

@IBOutlet weak var LeaderboardTableView: UITableView!
    
override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        LeaderboardTableView.delegate = self
        LeaderboardTableView.dataSource = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        username = []
        points = []
        rank = []
        
        getData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for :indexPath) as! LeaderboardTableViewCell
        
        print("we are here")
        cell.rank.text = "\(indexPath.row+1)"
        cell.username.text = userData[indexPath.row]["username"] as? String
        cell.points.text = "\(userData[indexPath.row]["points"] as! Int)" + " points"
        
        Firestore.firestore().collection("users").whereField("username", isEqualTo:userData[indexPath.row]["username"]).getDocuments
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
                        cell.pfp.image = UIImage(named: picture)
                        cell.pfp.layer.cornerRadius = cell.pfp.frame.size.width / 2
                        cell.pfp.clipsToBounds = true
                    }
                        
                }
            
            
        }
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("You tapped me")
    }
    var userData: [[String: Any]]  = []
    
    func getData() {
        
        username = []
        points = []
        
        functions.httpsCallable("getUsers").call()
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
            print("donb")
            if let userList = (result?.data as? [String: Any])?["userList"] as? [[String:Any]]
            {
                self.userData = userList
                self.LeaderboardTableView.reloadData()
            }
            print(self.userData)
        
}
        
}
    
}
