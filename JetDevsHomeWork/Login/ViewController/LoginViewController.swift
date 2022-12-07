//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Kavita Kishan on 05/12/22.
//

import UIKit

class LoginViewController: UIViewController, LoginHandlerDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailAlertMessage: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAlertMessage: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var canEnableLoginButton = false
    var loginHandler = LoginHandler()
    weak var delegate:UserInfoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        loginButton.backgroundColor = .lightGray
        emailAlertMessage.text = ""
        passwordAlertMessage.text = ""
        self.loginHandler.loginDelegate = self
    }

    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userLogin(_ sender: Any) {
        print("loginCalled")
        self.loginHandler.login(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func emailDidEnd(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        if(email != "" && isValidEmailEmailAddress(email)){
            if(canEnableLoginButton == true){
                loginButton.isEnabled = true
                loginButton.backgroundColor = .systemBlue
            }
            canEnableLoginButton = true
            emailAlertMessage.text = ""
        }
        else{
            loginButton.isEnabled = false
            canEnableLoginButton = false
            loginButton.backgroundColor = .lightGray
            emailAlertMessage.text = "This is a invalid email"
        }
    }
    
    
    @IBAction func passwordDidEnd(_ sender: Any) {
        guard let pwrd = passwordTextField.text else {return}
        if(pwrd != "" && isValidPassword(pwrd)){
            passwordAlertMessage.text = ""
            if(canEnableLoginButton == true){
                loginButton.isEnabled = true
                loginButton.backgroundColor = .systemBlue
            }
            canEnableLoginButton = true
        }
        else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = .lightGray
            canEnableLoginButton = false
            passwordAlertMessage.text = "Passwords require atleast 1 uppercase, 1 lowercase, and 1 number"
        }
    }
    
    func isValidEmailEmailAddress(_ emailAddress:String)->Bool{
        let regExpr: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", regExpr).evaluate(with: emailAddress)
    }
    
    func isValidPassword(_ password:String)->Bool{
        let regExpr:String = ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,16}")
        return NSPredicate(format: "SELF MATCHES %@", regExpr).evaluate(with: password)
    }
    
    func loginFailed(message errorMessage:String?)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            let messageTitle = "Login failed"
            var errMsg = errorMessage == nil ? "Failed to login" : errorMessage
            
            let alert = UIAlertController(title: messageTitle, message: errMsg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func loginSuccess(userInfo: UserInfo){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.delegate?.setUserInfo(userInfo: userInfo)
            self?.navigationController?.popViewController(animated: false)
        }
    }
    

}
