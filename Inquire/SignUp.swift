
import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var didAgree = false
    
    @IBOutlet weak var termsAndConditions: UIButton!
    override func viewDidLoad() {
            super.viewDidLoad()
            setUpElements()
            self.signUpButton.layer.cornerRadius = 25
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        //cbutton.layer.borderWidth = 1
        //cbutton.layer.borderColor = UIColor.lightGray.cgColor
        }
        func setUpElements() {
            //termsAndConditions.layer.cornerRadius = 10
            errorLabel.alpha = 0
        }
        
        func validateFields() -> String?
        {
            
            //Check that all fields are filled in
            if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                
                return "Please fill in all fields."
            }
            
            
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Utilities.isPasswordValid(cleanedPassword) == false {
                //Password isnt secure enough
                return "password must at least 8 characters,and contain a number and special character(examples: $,%,^,&)"
                
            }
                 
            
            return nil
            
    }
    lazy var functions = Functions.functions()
    let db = Firestore.firestore()
    var error:String? = ""
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEULA"
        {
            let vc = segue.destination as! eulaConditions
            vc.userName = self.userName
            vc.email = self.email
            vc.password  = self.password
        }
    }
    @IBAction func signUpTapped(_ sender: Any) {
    
        
            //Validate the fields
            self.error = self.validateFields()
        
            self.db.collection("users").whereField("username", isEqualTo: self.usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)).getDocuments { (QuerySnapshot,Error ) in
                print("diip")
                if let e = Error
                {
                    print(e.localizedDescription)
                }
                for document in QuerySnapshot!.documents
                {
                    if document.exists
                    {
                        if self.error == nil
                        {
                            self.error = "username is already in use"
                            break
                        }
                    }
                }
            }
        self.db.collection("users").whereField("email", isEqualTo: self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)).getDocuments { (QuerySnapshot,Error ) in
            print("diipdfd")

            if let e = Error
            {
                print(e.localizedDescription)
            }
            for document in QuerySnapshot!.documents
            {
                if document.exists
                {
                    if self.error == nil
                    {
                        self.error = "email is already in use"
                        break
                    }
                }
            }
        }
       
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            
        
            if self.error != nil
            {
                
                //There is something wrong with the fields, show error message
                self.showError(self.error!)
            }
            else
            {
                
                self.userName = self.usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                self.email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                self.password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                var username = self.userName
                var user = username.censor()
                self.performSegue(withIdentifier: "toEULA", sender: self)
            }

            Timer.invalidate()
        }
            
        
    }
    var userName = ""
    var email = ""
    var password = ""
            //Transition to the home screen
            
        
        func showError(_ message:String) {
            
            errorLabel.text = message
            errorLabel.alpha = 1
        }
        
        func transitionToHome() {
            /*
            let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
            */
            
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController") //REPLACE '"MainTabBarController"' with tabbed bar storyboard id
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
    
    @IBOutlet weak var cbutton: UIButton!
    @IBAction func cancelButton(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { self.view.endEditing(true)
           return false
           
       }
    
    @IBAction func toSignUp(_ segue: UIStoryboardSegue) {
        didAgree = true
        if errorLabel.text == "Please agree to Terms & Conditions"
        {
            errorLabel.text = ""
        }
    }
    }
