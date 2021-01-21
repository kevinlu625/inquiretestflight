//
//  InitiateViewController.swift
//  Inquire
//
//  Created by Kevin Lu on 7/28/20.
//  Copyright © 2020 Kevin Lu. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import UserNotifications
import AuthenticationServices
import NotificationCenter
import CryptoKit
class InitiateViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var googleSignInButton:
        GIDSignInButton!
    
    func performSignin()
    {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        
        
    }
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest
    {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName,.email]
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
        
    }
    func setUpAppleSignInButton()
    {
        
        let signinButton = ASAuthorizationAppleIDButton()
        
        signinButton.frame = CGRect(x:(self.view.safeAreaLayoutGuide.layoutFrame.size.width-240)/2
,y:(UIScreen.main.bounds.size.height/2+100),width: 240,height: 40)
        
        
        signinButton.addTarget(self, action: #selector(signInActionButton), for: .touchUpInside)
        self.view.addSubview(signinButton)
        
    }
    
    @objc func signInActionButton()
    {
        performSignin()
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    fileprivate var currentNonce: String?
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        termsText.delegate = self
        
        termsText.addHyperLinksToText(originalText: "By signing up or logging in, you are indicating that you have read and agree to our Terms & Conditions and Privacy Policy.\nContact us at: applicationinquire@gmail.com", hyperLinks: ["Terms & Conditions": link2Url, "Privacy Policy": linkUrl])

        
        
        
        
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.signUpButton.layer.cornerRadius = 20
        self.loginButton.layer.cornerRadius = 20
        
        let center = UNUserNotificationCenter.current()
               center.requestAuthorization(options: [.alert,.sound])
               { (granted, error)
                   in
                  
               }
        let content = UNMutableNotificationContent()
        content.title = "meme"
        content.body = "body"
        let date = Date().addingTimeInterval(10)
        let dateComponenets = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponenets, repeats: false)
        let uuid = UUID().uuidString
        print(uuid)
        print("notif")
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        //center.add(request) { (Error) in
            
        //}
        setUpAppleSignInButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            transitionToHome()
        }
    }
    
    func transitionToHome()
    {

           let storyboard = UIStoryboard(name: "Main", bundle:nil)
           let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

           (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

    @IBOutlet weak var termsText: UITextView!
    
    let linkUrl = "https://inquire.flycricket.io/privacy.html"
    let link2Url = "https://inquire.flycricket.io/terms.html"
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("interacted")
        if URL.absoluteString == linkUrl || URL.absoluteString == link2Url
        {
            UIApplication.shared.open(URL)
        }
        

        return true
    }
    
    
    
}
    
    
    
    
  @available(iOS 13.0, *)
extension InitiateViewController: ASAuthorizationControllerDelegate {

      func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
          let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if let user = authResult?.user
            {
                let username = ((appleIDCredential.fullName?.givenName)! +  " " + (appleIDCredential.fullName?.familyName)!)
                username.censored()
                let email = appleIDCredential.email
                print("authed")
                print(username)
                UserData.currentUser = username
                let db = Firestore.firestore()
                
                        //User was created successfully, now store the first name and last name

                        let user = Auth.auth().currentUser
                        let uid = user!.uid
                        
                db.collection("users").whereField("uid", isEqualTo: uid).getDocuments
                {
                    (QuerySnapshot, Error) in
                        if let Error = Error
                        {
                            print(Error.localizedDescription)
                        }
                        else
                        {
                            if QuerySnapshot!.documents.count > 0
                            {
                                print("DOCUMENT EXISTS")
                            }
                            else
                            {
                                
                                print("USER DOCUMENT CREATED")
                                db.collection("users").document(uid).setData(["username":username, "uid":uid, "profileImg":"default", "email": email!, "Points": 0]) { (error) in
                                    
                                    print("current username")
                                    print(username)

                                    if error != nil {

                                        //Show error message
                                        print("Error saving user data")
                                    }
                                }                            }
                        }
                }

                        //Transition to Home
                        self.transitionToHome()
                   
                
                
                
                }
            }
        
        }
      }

      func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
      }

    }
extension InitiateViewController:ASAuthorizationControllerPresentationContextProviding
{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}
extension NSAttributedString
{
    static func makeHyperlink(for path: String,for secondPath: String, in string: String, as substring: String, as subsubString: String) -> NSAttributedString {
        
        
        
       let nsString = NSString(string: string)
        
        
        
        
       let substringRange = nsString.range(of: substring)
        
        let subsubstringRange = nsString.range(of: subsubString)
        
        
       let attributedString = NSMutableAttributedString(string: string)
        
        
       attributedString.addAttribute(.link, value: path, range: substringRange)
       attributedString.addAttribute(.link, value: path, range: subsubstringRange)

       return attributedString
   }
}

extension UITextView {
    

      func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        for (hyperLink, urlString) in hyperLinks {
            let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
            let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
            attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
            attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: fullRange)
        }

        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.link,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        self.attributedText = attributedOriginalText
      }
    
}
