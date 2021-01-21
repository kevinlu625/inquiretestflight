//
//  ChannelTableViewCell.swift
//  Inquire
//
//  Created by Henry Liu on 8/8/20.
//  Copyright © 2020 Henry Liu. All rights reserved.
//

import UIKit
import FirebaseFunctions

class CelllllClass: UITableViewCell {

}

class ChannelTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var primaryAdminName: UILabel!
    
    var delagete: Announcements?
    var dalegete: ChannelSettings?
    var dg: LeaveChannel?
    override func awakeFromNib()
        {
            super.awakeFromNib()
            print(channelName.text!)
            thisTableView.delegate = self
            thisTableView.dataSource = self
            thisTableView.register(CelllllClass.self, forCellReuseIdentifier: "Celllll")
            print("ran")
            
        }
        
        @IBOutlet weak var btnChannel: UIButton!
        @IBAction func Click(_ sender: Any) {
            print("clicked")
            dataSource = ["Announcements","Settings", "Leave"]
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
          
          thisTableView.frame = CGRect(x: frames.origin.x - 130, y: frames.origin.y + frames.height, width: 170, height: 0)
          self.contentView.addSubview(thisTableView)
          
          //transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
          thisTableView.reloadData()
          
          let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
          transparentView.addGestureRecognizer(tapgesture)
          transparentView.alpha = 0
          UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
              self.transparentView.alpha = 0.5
            self.thisTableView.frame = CGRect(x: frames.origin.x - 130, y: frames.origin.y + frames.height + 5, width: 170, height: CGFloat(self.dataSource.count * 50))
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
              return 3
           }
        
        
          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("here")
            let celllll = self.thisTableView.dequeueReusableCell(withIdentifier: "Celllll", for: indexPath) as! CelllllClass
            print("for table view")
            dataSource = ["Announcements","Settings", "Leave"]
            celllll.textLabel?.text = dataSource[indexPath.row]
            return celllll
          }
          
          
          func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 50
          }
          
          
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("selected")
            if indexPath.row == 0
            {
            
                print("row 0")
                toAnnouncements(self)
            }
            else if indexPath.row == 1
            {
                print("row 1")
                toChannelSettings(self)
            }
            else
            {
                print("row 2")
                leaveChannel(self)
            }
            removeTransparentView()
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

        }
        
        
        func toChannelSettings(_ sender: Any)
        {
            print("barb")
            UserData.currentChannel = channelName.text!
            self.dalegete?.callSegueFromCellTwo(myData: self)
            print(UserData.currentChannel)
        }
        
        
        func toAnnouncements(_ sender: Any)
        {
            
            UserData.currentChannel = channelName.text!
            UserData.currentAdmin = primaryAdminName.text!
            self.delagete?.callSegueFromCell(myData: self)
            
        }
        
        
        func leaveChannel(_ sender: Any)
        {
            UserData.currentChannel = channelName.text!
            self.dg?.callSegueFromCellThree(myData: self)
        }
        
    }
