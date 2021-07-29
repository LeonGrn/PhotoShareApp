//
//  AddPageVC.swift
//  PhotoShareApp
//
//  Created by Leon Grinshpun on 23/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class AddPageVC: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    var selectedImage: UIImage?
    var username: String!
    var profileUserImg: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        getuserData()
        captionTextView.text = ""

        let tapGesture = UITapGestureRecognizer(target: self , action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        //let uid = Auth.auth().currentUser!.uid
        let uuid = UUID().uuidString

        let storageRef = Storage.storage().reference(forURL: "gs://photoshareapp-e81b2.appspot.com").child("posts").child(uuid)

        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
            storageRef.putData(imageData, metadata: nil, completion:{ (metadata,error) in
            if error != nil{
                return
            }
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else {
                      return
                    }
                    print(downloadURL)
                    let ref = Database.database().reference()

                    let _: Void = ref.child("Posts").child(uuid).setValue(["photoImageUrl" : downloadURL.absoluteString , "photoCaption" : self.captionTextView.text ?? "" , "userImgPath" : self.profileUserImg , "username" : self.username])
                    
                    self.captionTextView.text = ""
                    self.photo.image = UIImage(named: "placeholder-image")
                    self.tabBarController?.selectedIndex = 0
                })
            })

        }
    }
    
    func getuserData(){
        Database.database().reference().child("users").observe(.childAdded) { snapshot in
            for _ in snapshot.children {
                if let dict = snapshot.value as? [String : Any]{
                    self.username = dict["username"] as? String
                    self.profileUserImg = dict["profileImageUrl"] as? String
                    
                   
                }
            }
        }
    }
    

}

extension AddPageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            selectedImage = image
            photo.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
