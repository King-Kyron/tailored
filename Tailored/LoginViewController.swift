

//
//  LoginViewController.swift
//  Tailored
//
//  Created by Kyron Loggins on 8/6/17.
//  Copyright © 2017 Kyron Loggins (HiddenGenius). All rights reserved.
//


import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil{
            print("User is logged in")
            goToHome()
            //logout()
            
        }else{
            print("NOT logged in")
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            
            self.goToHome()
        })
    }
    func logout(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    func goToHome(){
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomePVC") as! UIPageViewController
        self.present(homeVC, animated: true, completion: nil)
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        login()
    }
    
}
