
//
//  ViewQuestionViewController.swift
//  Inquire
//
//  Created by Henry Liu on 9/20/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFunctions
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ViewQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    @IBOutlet weak var questionTableView: UITableView!

    lazy var functions = Functions.functions()
    var currentChannelName = UserData.currentChannel
    var questionData: [[String:Any]] = []
    var username :[String] = []
    var question : [String] = []
    var timer = Timer()
    var counter = 0
    var isLoad = false
    
    lazy var refresher : UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    @objc func requestData()
    {
        getQuestionData()
        let deadline = DispatchTime.now() + .milliseconds(3000)
        DispatchQueue.main.asyncAfter(deadline: deadline)
        {
            self.refresher.endRefreshing()
        }
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        isLoad = true
        print("past view question done")
        
        self.tabBarController?.delegate = self
        print(currentChannelName)
        authenticateUser()
        getQuestionData()
        currentChannelName = UserData.currentChannel
        print ("current channel name" + currentChannelName)
        questionTableView.refreshControl = refresher
        questionTableView.delegate = self
        questionTableView.dataSource = self
        questionTableView?.isPagingEnabled = true
       
       self.performSegue(withIdentifier: "toLoading", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if(!UserData.returningToViewQuestion)
        {
            print("past view question done")
            self.tabBarController?.delegate = self
            self.questionData = []
            self.username = []
            self.question = []
            //var counterDid = 0
            currentChannelName = UserData.currentChannel
            print ("current channel name" + currentChannelName)
            getQuestionData()
            
        }
        else
        {
            currentChannelName = UserData.currentChannel
            print ("current channel name" + currentChannelName)
            getQuestionData()
            UserData.returningToViewQuestion = false
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if question.count == 0{
            return 1
        }
        
        return question.count
    }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return questionTableView.bounds.height;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(indexPath.row)
        
        if question.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noContentCell1", for: indexPath)as! noContentCell1
            
            return cell
        }
        else if question.count > 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionsCell", for: indexPath)as! QuestionTableViewCell
            var recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewQuestionViewController.imageTapped(_:)))
            let imageID: String = self.currentChannelName + "-true-" + self.question[indexPath.item] + "-true"
            let photoRef = Storage.storage().reference().child(imageID)
            cell.questionImage.isUserInteractionEnabled = false
            if QImages.count > 0{
                if self.QImages[indexPath.row] == nil{
                cell.questionImage.image = nil
                cell.questionImage.isUserInteractionEnabled = false
                }
                else{
                cell.questionImage.image = UIImage(data:self.QImages[indexPath.row] as! Data)
                cell.questionImage.isUserInteractionEnabled = true
                cell.questionImage.addGestureRecognizer(recognizer)
                }
                
            }
            var s = self.PFP[indexPath.row] ?? "default"
            cell.profilePicture.image = UIImage(named:s ?? "default")
            cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2
            cell.profilePicture.clipsToBounds = true
            cell.username.text = self.username[indexPath.row]
            cell.question.text = self.question[indexPath.row]
            cell.channelName.text = self.currentChannelName
            print("herhe")
            print(cell.question.text)
            print(cell.username.text)
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func answerTapped(_ sender: Any)
    {
        self.performSegue(withIdentifier: "answerQuestion", sender: Any?.self)
    }
    func transitionerToStart()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "startStoryBoard")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

    func authenticateUser()
    {
        let db = Firestore.firestore()
        if Auth.auth().currentUser == nil
        {
            self.transitionerToStart()
        }
        else
        {
            db.collection("users").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid).getDocuments(completion:
            {
                (QuerySnapshot, Error) in
                if let err = Error
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    for document in QuerySnapshot!.documents
                    {
                        UserData.currentUser = document.data()["username"] as! String
                        print("current user")
                                
                    }
                }
            })
        }
    }
    var sentChannelName:String = ""
    var sentQuestionID:String = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if question.count > 0
        {
            sentChannelName = currentChannelName
            sentQuestionID = question[indexPath.row]
        }
        
    }

/*
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        print("r")
        sentChannelName = currentChannelName
        sentQuestionID = question[indexPath.row]
        UserData.currentChannel = sentChannelName
        UserData.currentQuestion = sentQuestionID
        self.performSegue(withIdentifier: "answerQuestions", sender: self)
        print("right")
        return nil
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print("r2")
               sentChannelName = currentChannelName
               sentQuestionID = question[indexPath.row]
               UserData.currentChannel = sentChannelName
               UserData.currentQuestion = sentQuestionID
               self.performSegue(withIdentifier: "toPastAnswers", sender: self)
               print("left")
        
            return nil
    }
 */
    
    //only viewdidload should have a loading screen
    var noDataOn = false
    var PFP:[Int:String?] = [:]
    var QImages:[Int:Any?] = [:]
    func getQuestionData()
     {
        let channelName = UserData.currentChannel
        self.PFP = [:]
        self.QImages = [:]
        self.questionData = []
        self.username = []
        self.question = []
        var username = UserData.currentUser
    
        functions.httpsCallable("genQuestionList").call(["channelName": channelName,"userName":UserData.currentUser])
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
                Crashlytics.crashlytics().log(error.localizedDescription)
                if(self.isLoad && error != nil)
                {
                    self.dismiss(animated: true, completion: nil)
                }
             }
           
            
                          
            
             //results in the form of an array of json objects
             if let questionsList = (result?.data as? [String: Any])?["questionList"] as? [[String:Any]]
             {
                 
                 //assigning local variable channelsData to channels list
                self.questionData = questionsList
             }
            self.question.removeAll()
            self.username.removeAll()
            self.PFP.removeAll()
            self.QImages.removeAll()
             if(self.questionData.count > 0)
             {
                
                for number in 0...self.questionData.count-1
                {
                        self.question.append(self.questionData[number]["QuestionText"] as! String)
                        self.username.append(self.questionData[number]["QuestionPoster"] as! String)
                        let imageID: String = self.currentChannelName + "-true-" + self.question[number] + "-true"
                        let photoRef = Storage.storage().reference().child(imageID)
                        photoRef.getData(maxSize:  40 * 1024 * 1024)
                        { (Data, Error) in
                                if let err = Error{
                                      print(err.localizedDescription)
                                      print("assigning to be nil")
                                    self.QImages[number] = nil
                                }
                                else{
                                    self.QImages[number] = Data
                                    print("assigning image")
                                }
                                Firestore.firestore().collection("users").whereField("username", isEqualTo:self.username[number]).getDocuments
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
                                                    self.PFP[number] = picture
                                                if self.PFP.count == self.questionData.count
                                                {
                                                    
                                                    self.questionTableView.reloadData()
                                                    self.dismiss(animated: true, completion: nil)
                                                }
                                                
                                            }
                                        }
                                }
                        }
                }
                
                
             }
            else
             {
                self.questionTableView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
            
         }

    }
    
    @IBAction func TapToQuestions(_ segue: UIStoryboardSegue)
    {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer)
    {
    
        let imageView:UIImageView? = sender.view as! UIImageView
      
        let newImageView = UIImageView(image: imageView!.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func backtoQuestions(_ segue: UIStoryboardSegue)
    {
             
               self.tabBarController?.selectedIndex = 0
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
         var visibleRect = CGRect()

         visibleRect.origin = questionTableView.contentOffset
         visibleRect.size = questionTableView.bounds.size
         let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
         guard let indexPath = questionTableView.indexPathForRow(at: visiblePoint)
             else { return }
            questionTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,withVelocity velocity: CGPoint,targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.scrollViewDidEndDecelerating(scrollView)
        }
    }
    /*
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath])
    {
        
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath])
    {
        
    }
     */

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex != 0 && noDataOn
        {
            dismiss(animated:true, completion:nil)
            noDataOn = false
        }
   }
    
    
}
protocol UITableViewDataSourcePrefetching {
  // This is called when the rows are near to the visible area
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath])

    
    
  
  // This is called when the rows move further away from visible area, eg: user scroll in an opposite direction
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath])

}
