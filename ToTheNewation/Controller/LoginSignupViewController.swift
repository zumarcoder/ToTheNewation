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
    @IBOutlet weak var loggedinUIView: UIView!
    @IBOutlet weak var profilePictureLogedinView: UIView!
    @IBOutlet weak var fNamelNameLabelLogedInView: UILabel!
    @IBOutlet weak var userIDlabelLogedInView: UILabel!
    @IBOutlet weak var subscribtionLogedInLabel: UILabel!
    @IBOutlet weak var logoutButtonLogedInView: UIButton!
    @IBOutlet weak var activityIndicatorLoginView: UIActivityIndicatorView!
    @IBOutlet weak var toastMessageLabel: UILabel!
    
    var textField: UITextField?
    var emailValidationCode: Int!
    var emailMessage: String!
    var signupValidationCode : Int!
    var signupMessage : String!
    var forgetPasswordCode : Int!
    var forgetPasswordMessage : String!
    var loginValidationCode : Int!
    var loginValidationMessage : String!
    
    
    struct LoginData {
        var firstName : String!
        var lastName : String!
        var iID : String!
        var Subscribtion : String!
    }
    var loginparams = LoginData(firstName: "", lastName: "", iID: "", Subscribtion: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        depthEffect(element: self.navigationController!.navigationBar, shadowColor: UIColor.lightGray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: loginInsideButtonLogin, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: forgetPasswordButtonLogin, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: loginButton, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: signUpButton, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: signupinsideButton, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: emailEditTextLogin, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: passwordEditTextLogin, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: firstNameEditTextSignup, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: lastnameEditTextSignup, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: mailEditTextSignup, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: passwordEditTextSignup, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: signupinsideButton, shadowColor: UIColor.gray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: profilePictureLogedinView, shadowColor: UIColor.gray, shadowOpacity: 10, shadowOffSet: CGSize(width: 0, height: 5), shadowRadius: 10)
        
        emailEditTextLogin.setLeftPaddingPoints(10)
        emailEditTextLogin.setRightPaddingPoints(50)
        passwordEditTextLogin.setLeftPaddingPoints(10)
        passwordEditTextLogin.setRightPaddingPoints(10)
        firstNameEditTextSignup.setLeftPaddingPoints(10)
        firstNameEditTextSignup.setRightPaddingPoints(10)
        lastnameEditTextSignup.setLeftPaddingPoints(10)
        lastnameEditTextSignup.setRightPaddingPoints(10)
        mailEditTextSignup.setLeftPaddingPoints(10)
        mailEditTextSignup.setRightPaddingPoints(10)
        passwordEditTextSignup.setLeftPaddingPoints(10)
        passwordEditTextSignup.setRightPaddingPoints(10)
        loginInsideButtonLogin.roundTheView(corner: 10)
        forgetPasswordButtonLogin.roundTheView(corner: 10)
        signupinsideButton.roundTheView(corner: 10)
        emailEditTextLogin.roundTheView(corner: 10)
        passwordEditTextLogin.roundTheView(corner: 10)
        firstNameEditTextSignup.roundTheView(corner: 10)
        lastnameEditTextSignup.roundTheView(corner: 10)
        mailEditTextSignup.roundTheView(corner: 10)
        passwordEditTextSignup.roundTheView(corner: 10)
        profilePictureLogedinView.roundTheView(corner: profilePictureLogedinView.frame.height/2)
        logoutButtonLogedInView.roundTheView(corner: 5)
        
        let tap = UITapGestureRecognizer(target: self.rootViewOfLoginAndSignup, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Login"
        if(UserDefaults.standard.bool(forKey: "loggedin"))
        {
            showProfileView()
        }
        else
        {
            hideProfileView()
        }
    }
    
    
    @IBAction func onTopLoginButtonTap(_ sender: Any) {
        loginView.isHidden = false
        signupView.isHidden = true
        self.navigationController?.navigationBar.topItem?.title = "Login"
        loginButton.layer.backgroundColor = UIColor.lightGray.cgColor
        signUpButton.layer.backgroundColor = UIColor.white.cgColor
    }
    
    
    @IBAction func onTopSignupButonTap(_ sender: Any) {
        loginView.isHidden = true
        signupView.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Sign Up"
        loginButton.layer.backgroundColor = UIColor.white.cgColor
        signUpButton.layer.backgroundColor = UIColor.lightGray.cgColor
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
        if emailEditTextLogin.text!.isEmpty || passwordEditTextLogin.text!.isEmpty
        {
            toastMessageLabel.toastMessageLabel(message: "Fill all the Field")
        }
        else
        {
            self.activityIndicatorLoginView.isHidden = false
            let mail = emailEditTextLogin.text!
            let password = passwordEditTextLogin.text!
            let parameters = [
                "mail" : mail ,
                "password" : password,
                "client_secret" : "abcde12345",
                "client_id" : "ec7c3bde-9f51-4113-9ecf-6ca6fd03b66b",
                "scope" : "ios",
                "grant_type" : "password" ,
                "deviceId" : "12345"
            ]
            
            func getPostDataAttributes(params:[String:String]) -> Data
            {
                var data = Data()
                for(key, value) in params
                {
                    let string = "--CuriousWorld\r\n".data(using: .utf8)
                    data.append(string!)
                    data.append(String.init(format: "Content-Disposition: form-data; name=%@\r\n\r\n", key).data(using: .utf8)!)
                    data.append(String.init(format: "%@\r\n", value).data(using: .utf8)!)
                    data.append(String.init(format: "--CuriousWorld--\r\n").data(using: .utf8)!)
                }
                return data
            }
        
            let parametersData = getPostDataAttributes(params: parameters)
            guard let url = URL(string: "https://qa.curiousworld.com/api/v3/Login?_format=json")
                else {
                    return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("multipart/form-data; boundary=CuriousWorld", forHTTPHeaderField: "Content-Type")
            request.httpBody = parametersData
            let session = URLSession.shared
            session.dataTask(with: request) {
                (data , response , error) in
                if let data = data
                {
                    do
                    {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        {
                            if let userData = json["data"] as? [String : Any]
                            {
                                guard let firstName = userData["firstName"] as? String else {
                                    return
                                }
                                //self.loginparams.firstName = firstName
                                //print(firstName)
                                guard let lastName = userData["lastName"] as? String else {
                                    return
                                }
                                //self.loginparams.lastName = lastName
                                guard let uID = userData["uid"] as? String else {
                                    return
                                }
                                //self.loginparams.iID = uID
                                guard let subscriptionStatus = userData["subscriptionStatus"] as? String else {
                                    return
                                }
                                //self.loginparams.Subscribtion = subscriptionStatus
                                UserDefaults.standard.set(true, forKey: "loggedin")
                                UserDefaults.standard.set(firstName, forKey: "fn")
                                UserDefaults.standard.set(lastName, forKey: "ln")
                                UserDefaults.standard.set(uID, forKey: "uid")
                                UserDefaults.standard.set(subscriptionStatus, forKey: "sub")
                            }
                            
                            if let statusmsg = json["status"] as? [String : Any]
                            {
                                guard let codeResponse = statusmsg["code"] as? Int else
                                {
                                    return
                                }
                                self.loginValidationCode = codeResponse
                                
                                guard let messageResponse = statusmsg["message"] as? String
                                    else
                                {
                                    return
                                }
                                self.loginValidationMessage = messageResponse
                                self.loginApiHandler()
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
        
    }
    
    
    func loginApiHandler()
    {
        if(loginValidationCode == 1)
        {
            DispatchQueue.main.async {
                self.showProfileView()
                self.toastMessageLabel.toastMessageLabel(message: self.loginValidationMessage)
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.activityIndicatorLoginView.isHidden = true
                self.toastMessageLabel.toastMessageLabel(message: self.loginValidationMessage)
            }
            
        }
    }
    
    
    func showProfileView()
    {
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.topItem?.title = "Profile"
            self.loggedinUIView.isHidden = false
            self.activityIndicatorLoginView.isHidden = true
            self.rootViewOfLoginAndSignup.isHidden = true
            self.loginButton.isHidden = true
            self.signUpButton.isHidden = true
            self.fNamelNameLabelLogedInView.text = "\(UserDefaults.standard.string(forKey: "fn")!)  \(UserDefaults.standard.string(forKey: "ln")!)"
            self.userIDlabelLogedInView.text = UserDefaults.standard.string(forKey: "uid")
            self.subscribtionLogedInLabel.text = UserDefaults.standard.string(forKey: "sub")
        }
    }
    
    
    func hideProfileView()
    {
        self.navigationController?.navigationBar.topItem?.title = "Login"
        loggedinUIView.isHidden = true
        rootViewOfLoginAndSignup.isHidden = false
        loginButton.isHidden = false
        signUpButton.isHidden = false
    }
    
    
    @IBAction func onSignupInsideButtonTap(_ sender: Any) {
        if firstNameEditTextSignup.text!.isEmpty || lastnameEditTextSignup.text!.isEmpty || mailEditTextSignup.text!.isEmpty || passwordEditTextSignup.text!.isEmpty
        {
            toastMessageLabel.toastMessageLabel(message: "Fill all the Field")
        }
        else
        {
            self.activityIndicatorLoginView.isHidden = false
            self.signupinsideButton.isEnabled = false
            let firstname = firstNameEditTextSignup.text!
            let lastname = lastnameEditTextSignup.text!
            let email = mailEditTextSignup.text!
            let password = passwordEditTextSignup.text!
            let parameters = ["firstName" : firstname , "lastName" : lastname, "mail" : email , "password" : password ]
            guard let url = URL(string: "https://qa.curiousworld.com/api/v3/SignUp")
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
        
    }
    
    
    func resetPassword()
    {
        let passwordResetTextField = textField!.text!
        let parameters = ["mail" : passwordResetTextField ]
        guard let url = URL(string: "https://qa.curiousworld.com/api/v3/ForgetPassword?_format=json")
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
        if(self.emailEditTextLogin.text == "")
        {
            self.emailValidatedLabel.text = ""
        }
        else
        {
            let mail = emailEditTextLogin.text
            let parameters = ["mail" : mail]
            guard let url = URL(string: "https://qa.curiousworld.com/api/v3/Validate/Email?_format=json")
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
                //                print(response)
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
                                print(self.emailMessage!)
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                
                }.resume()
        }
    }
    
    
    func emailValidation() {
        if(emailValidationCode == 1)
        {            DispatchQueue.main.async {
            self.emailValidatedLabel.text = "✓"
            }
        }
        else {
            DispatchQueue.main.async {
                self.emailValidatedLabel.text = "✗"
                self.toastMessageLabel.toastMessageLabel(message: self.emailMessage)
            }
        }
    }
    
    
    func signUpApiResponseHandling()
    {
        if signupValidationCode == 1
        {
            DispatchQueue.main.async {
                self.activityIndicatorLoginView.isHidden = true
                self.toastMessageLabel.toastMessageLabel(message: self.signupMessage)
                self.firstNameEditTextSignup.text = ""
                self.lastnameEditTextSignup.text = ""
                self.mailEditTextSignup.text = ""
                self.passwordEditTextSignup.text = ""
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.activityIndicatorLoginView.isHidden = true
                self.toastMessageLabel.toastMessageLabel(message: self.signupMessage)
            }
        }
        DispatchQueue.main.async {
            self.signupinsideButton.isEnabled = true
        }
        
    }
    
    
    func forgetPaswordApiResponseHandling()
    {
        DispatchQueue.main.async {
            
            if self.forgetPasswordCode == 0
            {
                self.toastMessageLabel.toastMessageLabel(message: "Ooops..! \(self.forgetPasswordMessage!)")
            }
            else
            {
                self.toastMessageLabel.toastMessageLabel(message: "Hello! \(self.textField!.text!) \(self.forgetPasswordMessage!)")
            }
        }
    }
    
    
    @IBAction func onLogOutButtonTap(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "loggedin")
        UserDefaults.standard.set("nil", forKey: "fn")
        UserDefaults.standard.set("nil", forKey: "ln")
        UserDefaults.standard.set("nil", forKey: "uid")
        UserDefaults.standard.set("nil", forKey: "sub")
        self.hideProfileView()
    }
    
}

