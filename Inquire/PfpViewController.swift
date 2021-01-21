//
//  PfpViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 8/10/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import UIKit
import Firebase

class PfpViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    var profilePicture = [ "Lion", "Turtle1", "Turtle2", "Bear", "Cat", "Owl", "Fox","Fish", "Dog","default","1","2","3","4","5"]
    
    @IBOutlet weak var pfpCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print("this ran")
        print(self.view.frame.width/3-1)
       return CGSize(width: 106, height: 199.0)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return profilePicture.count
       }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PfpCollectionViewCell
        
        cell.pfp.image = UIImage(named: self.profilePicture[indexPath.row])
            
        print(self.profilePicture[indexPath.row])
        
        cell.pfp.layer.cornerRadius = 100/2
        
        return cell

    }
    
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print(indexPath.item)
        //let alert = Utilities.createAlertController(title: "Done", message: "Profile picture has been changed.")
        //self.present(alert, animated: true, completion: nil)
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let uid = user!.uid
        UserData.currentPFP = self.profilePicture[indexPath.item]
        UserData.justChangedPFP = true
        print("iindicator")
        print(UserData.currentPFP)
        print(UserData.justChangedPFP)
        db.collection("users").document(uid).updateData(["profileImg": profilePicture[indexPath.item]])
        { (Error) in
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProfileViewController
        vc.currentPFP = UserData.currentPFP
        
    }
    

  /*  @IBAction func exitTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }*/
    

}
