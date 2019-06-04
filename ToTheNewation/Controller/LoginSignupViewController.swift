//
//  LoginSignupViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 19/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {
    
    @IBOutlet weak var rootViewOfLoginAndSignup: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailEditTextLogin: UITextField!
    @IBOutlet weak var passwordEditTextLogin: UITextField!
    @IBOutlet weak var forgetPasswordButtonLogin: UIButton!
    @IBOutlet weak var loginInsideButtonLogin: UIButton!
    @IBOutlet weak var firstNameEditTextSignup: UITextField!
    @IBOutlet weak var lastnameEditTextSignup: UITextField!
    @IBOutlet weak var mailEditTextSignup: UITextField!
    @IBOutlet weak var passwordEditTextSignup: UITextField!
    @IBOutlet weak var signupinsideButton: UIButton!
    
    var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self.rootViewOfLoginAndSignup, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Profile"
    }
    
    
    @IBAction func onTopLoginButtonTap(_ sender: Any) {
        loginView.isHidden = false
        signupView.isHidden = true
    }
    
    @IBAction func onTopSignupButonTap(_ sender: Any) {
        loginView.isHidden = true
        signupView.isHidden = false
    }
    
    @IBAction func onForgetPasswordButtonTap(_ sender: Any) {
        let alert = UIAlertController(title: "Forget Password", message: "Enter Email Address to reset password", preferredStyle:.alert)
        alert.addTextField(configurationHandler: textFieldHandler )
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: {action in self.resetPassword()}))
        self.present(alert, animated: true, completion: nil)
    }
    func textFieldHandler(textField: UITextField!)
    {
        if (textField) != nil {
            self.textField = textField!
            textField.placeholder = "Enter Email Address"
        }
    }
    @IBAction func onLoginButtonTap(_ sender: Any) {
    }
    
    @IBAction func onSignupInsideButtonTap(_ sender: Any) {
    }
    
    func resetPassword()
    {
        print(textField!.text!)
        if(textField!.text! == "")
        {
            let alert1 = UIAlertController(title: "Ooops...", message: "Enter Email Address Carefully", preferredStyle:.alert)
            alert1.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert1, animated: true, completion: nil)
        }
        
        if(true)
        {
            let alert1 = UIAlertController(title: "Password Successfully Sent", message: "Hello! \(textField!.text!) the password reset message has been successfully sent to Your profile please visit and reset your password thank You.", preferredStyle:.alert)
            alert1.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert1, animated: true, completion: nil)

        }
    }
    
    
    
}
