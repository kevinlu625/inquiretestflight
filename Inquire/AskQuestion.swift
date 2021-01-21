

import UIKit
import Firebase
import Photos
import FirebaseStorage
import FirebaseFirestore
import FirebaseFunctions
import FirebaseAuth

class CellClass: UITableViewCell {
    
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate,UITableViewDelegate, UITableViewDataSource,UITabBarDelegate, UITabBarControllerDelegate {
    
    lazy var functions = Functions.functions()

    private var collectionView: UICollectionView?
    private let storage = Storage.storage().reference()
    
    @IBOutlet weak var btnChannel: UIButton!
    @IBOutlet weak var dueDate: UITextField!
    @IBOutlet weak var typeQuestionField: UITextView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var imageLine1: UILabel!
    @IBOutlet weak var imageLine2: UILabel!
    
    
    
    let db = Firestore.firestore()

    let datePicker = UIDatePicker()
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    var selectedButton = UIButton()
    
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    var dataSource = [String] ()
    
    //var imagePickerController = UIImagePickerController ()
    
    var url:URL? = nil
    var imagePicker: UIImagePickerController! = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        submitButton.layer.cornerRadius = 10
        uploadImageButton.layer.cornerRadius = 10
        btnChannel.layer.cornerRadius = 10
        typeQuestionField.delegate = self
        imagePicker.delegate = self
        typeQuestionField.layer.borderWidth = 1
        typeQuestionField.layer.borderColor = UIColor.lightGray.cgColor
        typeQuestionField.layer.cornerRadius = 10
        typeQuestionField.additionDoneButton(title: 1, target: self, selector: #selector(tapDone(sender:)))
        typeQuestionField.textColor = UIColor.lightGray
        createDatePicker()
        
        imageLabel.alpha = 0
        deleteImageButton.alpha = 0
        imageLine1.alpha = 0
        imageLine2.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.url = nil
        self.imageLabel.text = ""
    }

    

    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }

    func createDatePicker() {
        
        dueDate.textAlignment = .center
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        // assign toolbar
        dueDate.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        dueDate.inputView = datePicker
        
        datePicker.datePickerMode = .dateAndTime

    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        dueDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func addTransparentView(frames: CGRect){
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                  self.transparentView.alpha = 0
             self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
              }, completion: nil)
        
    }
    
    @IBAction func onClickChannel(_ sender: Any)
    {
        db.collection("Channels").whereField("Users", arrayContains: UserData.currentUser).getDocuments()
               { (querySnapshot, err) in
                   if let err = err
                   {
                       print("Error getting documents: \(err)")
                   }
                   else
                   {
                   self.dataSource.removeAll()
                       for document in querySnapshot!.documents
                       {
                           self.dataSource.append(document.documentID)
                       }
                    
                   }
                self.selectedButton = self.btnChannel
                self.addTransparentView(frames: self.btnChannel.frame)
                
             }
                  
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        imageLabel.alpha = 0
        deleteImageButton.alpha = 0
        imageLine1.alpha = 0
        imageLine2.alpha = 0
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        
        imageLabel.alpha = 0
        deleteImageButton.alpha = 0
        imageLine1.alpha = 0
        imageLine2.alpha = 0
        
        let d = Date().addingTimeInterval(10)
        if btnChannel.titleLabel?.text == "Select Channel"
        {
            imageLabel.text = "please select a channel"
            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (Timer) in
                self.imageLabel.text = self.url?.absoluteString
            }
        }
        else if datePicker.date < d
        {
            imageLabel.text = "please select a valid due date"
            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (Timer) in
                self.imageLabel.text = self.url?.absoluteString
            }
        }
        else if typeQuestionField.text == "" || typeQuestionField.text == "Question Here"
        {
            imageLabel.text = "please write a valid question"
            Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { (Timer) in
                self.imageLabel.text = self.url?.absoluteString
            }
        }
        else
        {
            let user = Auth.auth().currentUser
            let questionPoster = user!.uid
            var dueDate = datePicker.date.description
            sentChannel = btnChannel.titleLabel!.text!
            
            self.performSegue(withIdentifier: "askQuestionToLoading", sender: self)
            var questionText = typeQuestionField.text!
            questionText.censor()
            functions.httpsCallable("createQuestion").call(["questionText": questionText, "dueDate":dueDate,"channelName":btnChannel.titleLabel!.text!,"questionPoster":UserData.currentUser,"isArchived": false])
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
                
                self.dismiss(animated: true, completion: nil)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toPopupQuestion", sender: self)

                }
               
                
                print("create question worked")
            }
            if self.url != nil {
                self.uploadToCloud(fileURL: self.url!)
            }
            
            btnChannel.setTitle("Select Channel", for: .normal)
            var defaultText: String = ""
            self.dueDate.text = defaultText
            self.typeQuestionField.text = defaultText
            self.imageLabel.text = ""

        }
        
        
        
        
        
       }
    var sentChannel = ""

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toPopupQuestion"
        {
            var vc = segue.destination as! PopUpViewController
            vc.channelName = sentChannel
        }
    }

    @IBAction func uploadImageTapped(_ sender: Any)
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
              imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: false, completion: nil)
        }
        
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.url = info[UIImagePickerController.InfoKey.imageURL] as? URL
        print(self.url)
        imageLabel.text = self.url?.absoluteString
        imageLabel.alpha = 1
        deleteImageButton.alpha = 1
        imageLine1.alpha = 1
        imageLine2.alpha = 1
        //let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        //postImageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }

       func uploadToCloud(fileURL:URL)
       {
           let storageRef = Storage.storage().reference()

           let data = Data()
        let imageID: String = btnChannel.titleLabel!.text! + "-true-" + typeQuestionField.text! + "-true"

           let photoRef = storageRef.child(imageID)

           let uploadTask = photoRef.putFile(from: fileURL, metadata: nil)
           {
               (metadata, error) in
                   guard let metadata = metadata else
                   {
                       print(error?.localizedDescription)
                       return
                   }
                self.url = nil
                print("uploaded")

            
           }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        typeQuestionField.resignFirstResponder()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
    
    var counter = 0
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if counter < 1
        {
            typeQuestionField.text = nil
            typeQuestionField.textColor = UIColor.black
            self.counter += 1
        }
    }
    
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    }

extension UITextView {
    
    func additionDoneButton(title: Int, target: Any, selector: Selector) {
        
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
