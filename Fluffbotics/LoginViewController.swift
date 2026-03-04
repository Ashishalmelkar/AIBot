//
//  LoginViewController.swift
//  Fluffbotics
//
//  Created by Equipp on 02/12/25.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var buttonViewRef: UIView!
    @IBOutlet weak var googleBtnRef: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        buttonViewRef.layer.cornerRadius = 10.0
        googleBtnRef.layer.cornerRadius = 10.0
        buttonViewRef.clipsToBounds = true
        googleBtnRef.clipsToBounds = true
        
        //1st time trying CICD //
    }
    
    @IBAction func loginBtnAtn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Google Sign-In Error:", error.localizedDescription)
                return
            }
            guard let signInResult = signInResult else { return }
        
            let user = signInResult.user
            
            // Save login state for auto-login
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            print("User Email:", user.profile?.email ?? "")
            print("User Name:", user.profile?.name ?? "")
            if let imageURL = user.profile?.imageURL(withDimension: 200)?.absoluteString {
                UserDefaults.standard.set(imageURL, forKey: "userProfilePic")
            }
            UserDefaults.standard.set(user.profile?.name, forKey: "userName")
            UserDefaults.standard.set(user.profile?.email, forKey: "userEmail")

            // After login → Go to Dashboard
            (UIApplication.shared.delegate as? AppDelegate)?.showDashboard()
        }
    }
}
