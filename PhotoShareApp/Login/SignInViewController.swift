//
//  SignInViewController.swift
//  PhotoShareApp
//
//  Created by Leon Grinshpun on 23/07/2021.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signIn_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.backgroundColor = UIColor.black
        emailTextField.tintColor = UIColor.white
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0,alpha:0.6)])
        passwordTextField.backgroundColor = UIColor.black
        passwordTextField.tintColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor(white:1.0,alpha:0.6)])
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x:0 , y:29 , width: 1000, height: 0.6)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        emailTextField.layer.addSublayer(bottomLayer)
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x:0 , y:29 , width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor.gray.cgColor
        passwordTextField.layer.addSublayer(bottomLayerPassword)
        
        handleTextField()

    }
    
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(){
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signIn_btn.setTitleColor(UIColor.lightText , for: UIControl.State.normal)
            signIn_btn.isEnabled = false
            return
        }
        signIn_btn.setTitleColor(UIColor.white , for: UIControl.State.normal)
        signIn_btn.isEnabled = true

    }

    @IBAction func signInButton_TouchUpInside(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if error != nil{
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{action in
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
//                self.performSegue(withIdentifier: "MainVC", sender: nil)
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                   if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC") as? UIViewController {
                       self.present(viewController, animated: true, completion: nil)
                   }
            }
//            self.performSegue(withIdentifier: "signInToTabbarVC", sender: nil)
            
            
//            @IBAction func signIn(_ sender: UIButton) {
//                    let email = emailTXT.text
//                    let password = passwordTXT.text
//                    Auth.auth().signIn(withEmail: email!, password: password!) { authResult, error in
//                        if (error != nil){
//                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{action in
//                                    }))
//                                    self.present(alert, animated: true, completion: nil)
//                        }else {
//                            //move to next screen
//                            print("moved")
//                            self.moveToMainScreen()
//                        }
//                    }
//                }
        }
    }
}
