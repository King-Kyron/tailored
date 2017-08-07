//
//  EditProViewController.swift
//  Tailored
//
//

import UIKit
import Firebase
import SDWebImage



class profileEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @IBOutlet weak var profileImageView: UIImageView!
        @IBOutlet weak var usernameText: UITextField!
        @IBOutlet weak var displayNameText: UITextField!
        @IBOutlet weak var bioText: UITextField!
    
        var databaseRef: DatabaseReference!
        var storageRef: StorageReference!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            databaseRef = Database.database().reference()
            storageRef = Storage.storage().reference()
            
            loadProfileData()
            
        }
    
    @IBAction func saveProfileData(_ sender: Any) {
        updateUsersProfile()
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func updateUsersProfile() {
        
        //        ensure user is logged in
        if let userID = Auth.auth().currentUser?.uid {
            //        create access point to storage
            let storageItem = storageRef.child("profile_images").child(userID)
            //        get image from photo library
            guard let image = profileImageView.image else {
                return
            }
            //        upload to firbase storage
            if let newImage = UIImagePNGRepresentation(image) {
                storageItem.putData(newImage, metadata: nil, completion: { (metadata, error) in
                    //storageRef.put(newImage, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    storageItem.downloadURL(completion: { (url, error) in
                    //self.storageRef.downloadURL(completion: { (url, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if let photoURL = url?.absoluteString {
                            guard let newUserName = self.usernameText.text else {
                                return
                            }
                            guard let newDisplayName = self.displayNameText.text else {
                                return
                            }
                            
                            let newValueForProfile = ["photo": photoURL, "username": newUserName,"displayName": newDisplayName]
                            //        and also to it's database
                            
                            self.databaseRef.child("profile").child(userID).updateChildValues(newValueForProfile, withCompletionBlock: { (error, reference) in
                                
                                if error != nil {
                                    return
                                }
                                print("Profile Successfully Upadted")
                                
                            })
                        }
                        
                    })
                })
                
                
            }
            
        }
        
    }
    
    

//    func updateUsersProfile(){
//      //check to see if the user is logged in
//        if let userID = FIRAuth.auth()?.currentUser?.uid{
//        //create an access point for the Firebase storage
//            let storageItem = storageRef.child("profile_images").child(userID)
//        //get the image uploaded from photo library
//            guard let image = profileImageView.image else {return}
//            if let newImage = UIImagePNGRepresentation(image){
//        //upload to firebase storage
//                storageItem.put(newImage, metadata: nil, completion: { (metadata, error) in
//                    if error != nil{
//                        print(error!)
//                        return
//                    }
//                    storageItem.downloadURL(completion: { (url, error) in
//                        if error != nil{
//                            print(error!)
//                            return
//                        }
//                        if let profilePhotoURL = url?.absoluteString{
//                            guard let newUserName  = self.usernameText.text else {return}
//                            guard let newDisplayName = self.displayNameText.text else {return}
//                            guard let newBioText = self.bioText.text else {return}
//                            
//                            let newValuesForProfile =
//                            ["photo": profilePhotoURL,
//                             "username": newUserName,
//                             "display": newDisplayName,
//                             "bio": newBioText]
//                            
//                            //update the firebase database for that user
//                            self.databaseRef.child("profile").child(userID).updateChildValues(newValuesForProfile, withCompletionBlock: { (error, ref) in
//                                if error != nil{
//                                    print(error!)
//                                    return
//                                }
//                                print("Profile Successfully Update")
//                            })
//                            
//                        }
//                    })
//                })
//      
//            }
//        }
//    }
    
    
    
    
    
    
    
    
    
    
//set up button action
    @IBAction func getPhotoFromLibrary(_ sender: Any) {
        //create instance of Image picker controller
        let picker = UIImagePickerController()
        //set delegate
        picker.delegate = self
        //set details
            //is the picture going to be editable(zoom)?
        picker.allowsEditing = false
            //what is the source type
        picker.sourceType = .photoLibrary
            //set the media type
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //show photoLibrary
        present(picker, animated: true, completion: nil)
    }
    //what happens when the user selects a photo?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        //create holder variable for chosen image
        var chosenImage = UIImage()
        //save image into variable
        print(info)
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //update image view
        profileImageView.image = chosenImage
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    //what happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    func loadProfileData(){
            
            //if the user is logged in get the profile data
            
            if let userID = Auth.auth().currentUser?.uid{
                databaseRef.child("profile").child(userID).observe(.value, with: { (snapshot) in
                    
                    //create a dictionary of users profile data
                    let values = snapshot.value as? NSDictionary
                    
                    //if there is a url image stored in photo
                    if let profileImageURL = values?["photo"] as? String{
                        //using sd_setImage load photo
                        self.profileImageView.sd_setImage(with: URL(string: profileImageURL), placeholderImage: UIImage(named: "empty-profile-1.png"))
                    }
                
                    self.usernameText.text = values?["username"] as? String
                    
                    
                    self.displayNameText.text = values?["display"] as? String
                    
        
                    self.bioText.text = values?["bio"] as? String
                })
                
            }//end of if
        }//end of loadProfileData

    
    
}


