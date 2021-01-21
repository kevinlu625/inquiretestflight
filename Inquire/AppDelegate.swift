
import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseAuth
import GoogleSignIn
import FirebaseInstanceID
import FirebaseFirestore
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if let error = error
        {
            print(error.localizedDescription)
            return
        }
        else
        {
            guard let authenication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authenication.idToken, accessToken: authenication.accessToken)
            var email = user.profile.email
            print(email)
            var index = email!.index(of: "@") ?? email?.endIndex
            
            email = email?.substring(to: index!)
            print(email)
            let db = Firestore.firestore()
            Auth.auth().signIn(with: credential)
            {
                (result, error) in
                if error == nil
                {
                    print(result?.user.email)
                    print(result?.user.displayName)
                    let user1 = Auth.auth().currentUser
                    let uid = user1!.uid
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
                                    db.collection("users").document(uid).setData([ "username": email, "uid":uid, "profileImg":"default", "Points": 0])
                                }
                            }
                    }
                
                }
                else
                {
                    print(error?.localizedDescription)
                }

            }
            if GIDSignIn.sharedInstance()?.currentUser != nil
            {
                print("WW")
                transitionToHome()
            }
        }
    }
    func transitionToHome()
    {

            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
           // Called when the user discards a scene session.
           // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
           // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
       }
       
     func registerPushNotification()
     {
            UNUserNotificationCenter.current()
                       .requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
                           print("Permission granted: \(granted)")
                   }
       }
        
       
       
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerPushNotification()
        FirebaseApp.configure()
        if let user = Auth.auth().currentUser
        {
            transitionToHome()
        }
        GIDSignIn.sharedInstance()?.clientID = "490999352976-85tqv3nls5mohhrniq91mt425gspvtha.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            print("here here here")
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
            
        } else {print("here here")
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        print("done")
    
        return true
    }
    

   

    let gcmMessageIDKey = "GCMKey"
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
        print(userInfo)
        print("received notifiaction")
        
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
        
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
               center.add(request) { (Error) in
                   
            }
    }



    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
        print(userInfo)
        print("received notifiaction")
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator
    //Unable to register for remote notifications: remote notifications are not supported in the simulator

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       print("Unable to register for remote notifications: \(error.localizedDescription)")
        
     }
    

     // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
     // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
     // the FCM registration token.

}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print(userInfo)
    print("will preesent")
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    print("didReceive response")
    let userInfo = response.notification.request.content.userInfo
    print(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?){
    print("Firebase registration token: \(fcmToken)")
        UserData.currentRegistrationToken = fcmToken!
    print(UserData.currentUser)
    print("and we are here")
    print(UserData.currentRegistrationToken)
    let db = Firestore.firestore()
    print(Auth.auth().currentUser?.uid)
    if(Auth.auth().currentUser?.uid != nil)
    {
        db.collection("users").document((Auth.auth().currentUser?.uid)!
        ).updateData(["registrationToken" : UserData.currentRegistrationToken])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    let dataDict:[String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        Messaging.messaging().apnsToken = deviceToken
        InstanceID.instanceID().instanceID { (result, error) in
        if let error = error {
        print("Error fetching remote instange ID: \(error)")
        } else if let result = result {
        print("Remote instance ID token: \(result.token)")
         }
        }
       print(deviceToken)
    }
  // [END refresh_token]
}
