//
//  MyPastCommentTableViewCell.swift
//  Inquire
//
//  Created by Kevin Lu on 1/1/21.
//  Copyright © 2021 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions

class MyPastCommentTableViewCell: UITableViewCell, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var pfp: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var dropDown: UIButton!
    @IBOutlet weak var comment: UITextView!
    
    func resizeTextViewFrame()
    {
        comment?.delegate = self
        
        let fixedWidth = comment?.frame.size.width
        
        let newSize: CGSize = comment!.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat(MAXFLOAT)))
        
        var newFrame = comment!.frame
        
        newFrame.size = CGSize(width: CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth!))), height: newSize.height)
        
        comment!.frame = newFrame
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        thisTableView.delegate = self
           thisTableView.dataSource = self
           thisTableView.register(CellllClass.self, forCellReuseIdentifier: "Cell")
           print("ran")
    }
    
    var answerID = ""
      
    lazy var functions = Functions.functions()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    }
    
    func deleteReply() {
       UserData.currentAnswer = answerID
       UserData.currentReply = comment.text!
    }
    
    @IBAction func onClick(_ sender: Any)
    {
        
            print("clicked the click")
            dataSource = ["Delete", "Block User"]
            self.selectedButton = self.dropDown
            self.addTransparentView(frames: self.dropDown.frame)
        
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
        thisTableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
       transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.thisTableView.frame = CGRect(x: frames.origin.x-120, y: frames.origin.y + frames.height + 5 + 10, width: 150, height: CGFloat(self.dataSource.count * 50))
        })
        {
            (bool) in
            print(bool ,"added fram")
            //self.thisTableView.reloadData()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row at")
        let cell = self.thisTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellllClass
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row")
        if indexPath.row == 0
        {
            print("row0")
            deleteReply()
        }
        else
        {
            print("row1")
            blockUser()
        }

        removeTransparentView()
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
    
     /*func reportAnswer() {
        let flagger = UserData.currentUser
        let channelID = UserData.currentChannel
        let questionID = UserData.currentQuestion
        let answerID = answer.text!
        functions.httpsCallable("flagAnswer").call(["flagger":flagger,"channelID":channelID,"questionID":questionID,"answerID":answerID])
        {
            (result, error) in
            if let error = error as NSError?
            {
                if error.domain == FunctionsErrorDomain
                {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    print(message)
                }
            }
            print("report Answer")

        
    }

    }*/

}
