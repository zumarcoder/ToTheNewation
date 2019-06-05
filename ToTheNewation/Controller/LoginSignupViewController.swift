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
    @IBOutlet weak var emailValidatedLabel: UILabel!
    
    var textField: UITextField?
    var emailValidationCode: Int!
    var emailMessage: String!
    var signupValidationCode : Int!
    var signupMessage : String!
    var forgetPasswordCode : Int!
    var forgetPasswordMessage : String!
    
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
        let firstname = firstNameEditTextSignup.text!
        let lastname = lastnameEditTextSignup.text!
        let email = mailEditTextSignup.text!
        let password = passwordEditTextSignup.text!
        
        let parameters = ["firstName" : firstname , "lastName" : lastname, "mail" : email , "password" : password ]
        
        guard let url = URL(string: "https://qa.curiousworld.com/api/v2/SignUp")
            else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpbody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            else {
            return
        }
        request.httpBody = httpbody
        let session = URLSession.shared
        session.dataTask(with: request) {
            (data , response , error ) in
            if let data = data
            {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    {
                        if let signupStatusCode = json["status"] as? [String : Any]
                        {
                            guard let signupcoderesp = signupStatusCode["code"] as? Int
                            else
                            {
                                return
                            }
                            self.signupValidationCode = signupcoderesp
                            //print(self.signupValidationCode!)
                        }
                        
                        if let signupStatusMessage = json["status"] as? [String : Any]
                        {
                            guard let signupStatusMessage = signupStatusMessage["message"] as? String
                            else
                            {
                                return
                            }
                            self.signupMessage = signupStatusMessage
                            //print(self.signupMessage!)
                            self.signUpApiResponseHandling()
                        }
                    }
                }
                catch
                {
                    print(error)
                }
            }
        }.resume()
}
    
    
    func resetPassword()
    {
        let passwordResetTextField = textField!.text!
        let parameters = ["mail" : passwordResetTextField ]
        guard let url = URL(string: "https://qa.curiousworld.com/api/v2/ForgetPassword?_format=json")
            else{
                return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        
        session.dataTask(with: request) {
            (data , error , response) in
            if let data = data
            {
                do
                {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    {
                        if let forgetpassword = json["status"] as? [String : Any]
                        {
                            guard let forgetPasswordResponseCode = forgetpassword["code"] as? Int
                            else
                            {
                                return
                            }
                            self.forgetPasswordCode = forgetPasswordResponseCode
                        }
                        
                        if let forgetPassword = json["status"] as? [String : Any]
                        {
                            guard let forgetPasswordResponseMessage = forgetPassword["message"] as? String
                            else
                            {
                                return
                            }
                            self.forgetPasswordMessage = forgetPasswordResponseMessage
                        }
                        self.forgetPaswordApiResponseHandling()

                    }
                }
                catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    
    @IBAction func mailEditTextEditingDidEnd(_ sender: Any) {
        let mail = emailEditTextLogin.text
        let parameters = ["mail" : mail]
        guard let url = URL(string: "https://qa.curiousworld.com/api/v2/Validate/Email?_format=json")
            else{
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            else {
            return
        }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
//            if let response = response {
//         //       print(response)
//            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        if let statusCode = json["status"] as? [String:Any]{
//                            print(statusCode)
                            guard let codeResponse = statusCode["code"] as? Int else {return}
//                            print("=========================== \(codeResponse)")
                            self.emailValidationCode = codeResponse
                            self.emailValidation()
                        }
                        if let statusMessage = json["status"] as? [String:Any]{
//                            print(statusMessage)
                            guard let codeResponseMessage = statusMessage["message"] as? String else {return}
//                            print("=========================== \(codeResponseMessage)")
                            self.emailMessage = codeResponseMessage
                        }
                    }
                } catch {
                    print(error)
                }
            }
            
            }.resume()
//        print(emailValidationCode)
//        print(emailMessage)
        
    }
    
    
    func emailValidation() {
        if(emailValidationCode == 1)
        {            DispatchQueue.main.async {
            self.emailValidatedLabel.isHidden = false
            }
        }
        else {
                DispatchQueue.main.async {
                self.emailValidatedLabel.isHidden = true
                let alert1 = UIAlertController(title: "Email", message: "We could not find any account with this email.", preferredStyle:.alert)
                alert1.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert1, animated: true, completion: nil)
            }
        }
    }

    func signUpApiResponseHandling()
    {
        if signupValidationCode == 1
        {
            let alert1 = UIAlertController(title: "Thank You", message: signupMessage , preferredStyle:.alert)
            alert1.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert1, animated: true, completion: nil)
        }
        else
        {
            let alert1 = UIAlertController(title: "Sorry", message: signupMessage , preferredStyle:.alert)
            alert1.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert1, animated: true, completion: nil)
        }
    }

    func forgetPaswordApiResponseHandling()
    {
                    
                    DispatchQueue.main.async {
                        
                        if self.forgetPasswordCode == 0
                        {
                            let alert1 = UIAlertController(title: "Ooops...", message: self.forgetPasswordMessage, preferredStyle:.alert)
                            alert1.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                            self.present(alert1, animated: true, completion: nil)
                        }
                        else
                        {
                        let alert1 = UIAlertController(title: "Password Successfully Sent", message: "Hello! \(self.textField!.text!) \(self.forgetPasswordMessage!)", preferredStyle:.alert)
                        alert1.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert1, animated: true, completion: nil)
                    }
                }
        }
}

