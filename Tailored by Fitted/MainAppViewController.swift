//
//  MainAppViewController.swift
//  Tailored by Fitted
//
//  Created by Kyron Loggins on 8/7/17.
//  Copyright © 2017 Kyron Loggins (HiddenGenius). All rights reserved.
//

import UIKit
import Firebase

class MainAppViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func logoutAction(){
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            let storyB = UIStoryboard.init(name: "Main", bundle: nil)
            storyB.instantiateViewController(withIdentifier: "LoginVC")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @IBAction func logoutAction(_ sender: Any) {
        print("Logout button pushed")
        logoutAction()
    }
}
