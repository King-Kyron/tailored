//
//  SignupViewController.swift
//  Tailored
//
//  Created by Kyron Loggins on 8/6/17.
//  Copyright © 2017 Kyron Loggins (HiddenGenius). All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    var usernameRef: DatabaseReference!
    
    
    var domain = "@playground.com"
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameRef = Database.database().reference().child("username")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
//            self.presentLoggedInScreen()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        if let playerUsername = usernameTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: playerUsername + domain, password: password, completion: { user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
 //               self.presentLoggedInScreen()
                self.usernameRef.child(playerUsername).setValue(playerUsername)
            })
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: username + domain, password: password, completion: { (user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
 //               self.presentLoggedInScreen()
            })
        }
    }
    
//    func presentLoggedInScreen() {
//        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let signupVC:SignupVC = storyboard.instantiateViewController(withIdentifier: "signupVc") as SignupVC
//        self.present(signupVC, animated: true, completion: nil)
//    }
    
    
    
    
    
    
    
    
    
    
}
