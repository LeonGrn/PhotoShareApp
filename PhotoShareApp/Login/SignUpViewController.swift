//
//  SignUpViewController.swift
//  PhotoShareApp
//
//  Created by Leon Grinshpun on 23/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUp_btn: UIButton!
    
    var selectedImage: UIImage?
    
//    let uuid = UUID().uuidString
//
//    let storageRef = Storage.storage().reference(forURL: "gs://photoshareapp-e81b2.appspot.com").child("posts").child(uuid)
//
//    if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
//        storageRef.putData(imageData, metadata: nil, completion:{ (metadata,error) in
//        if error != nil{
//            return
//        }
//            storageRef.downloadURL(completion: { (url, error) in
//                guard let downloadURL = url else {
//                  return
//                }
//                print(downloadURL)
//                let ref = Database.database().reference()
//
//                let _: Void = ref.child("Posts").child(uuid).setValue(["photoImageUrl" : downloadURL.absoluteString , "photoCaption" : self.captionTextView.text ?? ""])
//
//                self.captionTextView.text = ""
//                self.photo.image = UIImage(named: "placeholder-image")
//                self.tabBarController?.selectedIndex = 0
//            })
//        })
//
//    }
//
    @IBAction func signUpBtn(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {authResult, error in
            if(error != nil){
                print(error?.localizedDescription ?? "")
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{action in
                   }))
                self.present(alert, animated: true, completion: nil)
            }else{
                
           
            let uid = Auth.auth().currentUser!.uid

            let storageRef = Storage.storage().reference(forURL: "gs://photoshareapp-e81b2.appspot.com").child("profile_image").child(uid)
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
            
                            let usersReference = ref.child("users")
                            let newUserReference = usersReference.child(uid)
                            newUserReference.setValue(["username": self.usernameTextField.text! , "email":self.emailTextField.text! , "profileImageUrl": downloadURL.absoluteString])
                            
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC") as? UIViewController {
                                self.present(viewController, animated: true, completion: nil)
                                }
                        })
                    })
            }
        }
    }
}

    @IBAction func dismidd_onClick(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.backgroundColor = UIColor.black
        usernameTextField.tintColor = UIColor.white
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0,alpha:0.6)])

        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x:0 , y:29 , width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        usernameTextField.layer.addSublayer(bottomLayer)
        
        passwordTextField.backgroundColor = UIColor.black
        passwordTextField.tintColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0,alpha:0.6)])

        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x:0 , y:29 , width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor.gray.cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)

        emailTextField.backgroundColor = UIColor.black
        emailTextField.tintColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0,alpha:0.6)])

        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x:0 , y:29 , width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor.gray.cgColor
        emailTextField.layer.addSublayer(bottomLayerEmail)

        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self , action: #selector(SignUpViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        handleTextField()

    }
    
    func handleTextField(){
        usernameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(){
        guard let username = usernameTextField.text,!username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUp_btn.setTitleColor(UIColor.lightText , for: UIControl.State.normal)
            signUp_btn.isEnabled = false
            return
        }
        signUp_btn.setTitleColor(UIColor.white , for: UIControl.State.normal)
        signUp_btn.isEnabled = true

    }
    
    @objc func handleSelectProfileImageView(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}
