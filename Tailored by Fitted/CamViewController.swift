//
//  CameraViewController.swift
//  Tailored by Fitted
//
//  Created by Kyron Loggins on 8/7/17.
//  Copyright © 2017 Kyron Loggins (HiddenGenius). All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    var storageRef: StorageReference!
    var databaseRef: DatabaseReference!
    
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageRef = Storage.storage().reference()
        databaseRef = Database.database().reference()
        
    }
    //UI Button Actions
    @IBAction func sharePhoto(_ sender: Any) {
        //get the userid
        let userID = Auth.auth().currentUser?.uid
        //get timestamp
        let postID = NSUUID().uuidString
        //load the image into storage
        let postItem = storageRef.child("post").child(userID!).child(postID)
        //get image from imageview
        guard let postImage = postImageView.image else{return}
        guard let postCaption = captionTextView.text else{return}
        //convert image to PNG
        if let imageToUpload = UIImagePNGRepresentation(postImage){
            postItem.putData(imageToUpload, metadata: nil) { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                //get image URL from storage
                postItem.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let imageURL = url?.absoluteString{
                        //create instance of a post
                        let post = Post(userID: userID!, postID: postID, imageURL: imageURL, caption: postCaption)
                        
                        //save post to database
                        self.databaseRef.child("posts").child(userID!).child(postID).updateChildValues(post.getPostAsDictionary(), withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomePVC") as! UIPageViewController
                            self.present(homeVC, animated: true, completion: nil)
                        })
                        
                    }
                })
            }
            
            
        }
    }
    @IBAction func cancelUpload(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pickPhotoFromGallery(_ sender: Any) {
        getPhotoFromLibrary()
    }
    @IBAction func takePhotoAction(_ sender: Any) {
        takeNewPhoto()
    }
    //end of UI Button Actions
    //get a photo from our devices library
    func getPhotoFromLibrary(){
        picker.delegate = self
        picker.allowsEditing = false
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(picker, animated: true, completion: nil)
    }
    //camera for new photo
    func takeNewPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
        }else{
            noCameraAvailable()
        }
    }
    func noCameraAvailable(){
        let alertVC = UIAlertController(title: "No Camera Available", message: "Can't find a camera on this device", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    //function for image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        postImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    //when user cancels the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
