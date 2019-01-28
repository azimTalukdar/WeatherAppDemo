//
//  ViewController.swift
//  WeatherAppDemo
//
//  Created by Apple on 26/01/19.
//  Copyright © 2019 AzimTalukdar. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    //MARK:- variable
    //IBOutlet

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
//        {
//        didSet {fbLoginButton.readPermissions = ["public_profile", "email"]}
//        }
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    //Constant
    let googleClientID = "719372698599-d16l17m812c4pqp57b6dco657fjj2s8s.apps.googleusercontent.com"
    
    //Variable
    
    
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //Facebook
        
        if ((FBSDKAccessToken.current()) != nil) {
            // User is logged in, do work such as go to next view controller.
            fetchFBProfile()
        }
        
        //Google
        GIDSignIn.sharedInstance().clientID = googleClientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK:- Google delegates
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            // ...
            
            print("complete with login google")
            print("name: \(fullName!)")
            print("email: \(email!)")
            if user.profile.hasImage {
                let profileImage = user.profile.imageURL(withDimension: 200)
                print("profile: \(profileImage!)")
            }
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    //MARK:- Facebook delegate and methods
    
    func fetchFBProfile() {
        print("fetchFBProfile")
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
//        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
//            if let error = error {
//                print("\(error.localizedDescription)")
//            } else {
//                if let email = result!["email"] as? String {
//                    print("facebook email \(email)")
//                }
//            }
//        }
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start(completionHandler: { connection, result, error in
            if error == nil {
                guard let userInfo = result as? [String: Any] else { return }
                
//                    print("fetched user:\(userInfo)")
                    let userID = userInfo["id"]
                    var facebookProfileUrl = "http://graph.facebook.com/\(userID!)/picture?type=large"
                    let firstName = userInfo["first_name"]
                    let last_name = userInfo["last_name"]
                    let email = userInfo["email"]
                
                print("name: \(firstName!) \(last_name!)")
                print("email: \(email!)")
                print("profile: \(facebookProfileUrl)")
            }
        })
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            fetchFBProfile()
        }
        print("complete with login")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("complete with logout facebook")
    }

}

