//
//  LoginHandler.swift
//  JetDevsHomeWork
//
//  Created by Kavita Kishan on 06/12/22.
//

import Foundation


protocol LoginHandlerDelegate:AnyObject {
    func loginFailed(message errorMessage: String?)
    func loginSuccess(userInfo: UserInfo)
    //func x_account(accountInfo: Any?)
}

class LoginHandler: NSObject{
    
    private let urlString: String = "https://jetdevs.mocklab.io/login"
    weak var loginDelegate: LoginHandlerDelegate?
    private var xAcct: String?
    
    func login(email emailId: String, password paswrd: String){
      
        guard let loginURL = URL(string: urlString) else {return}
        let postModel = LoginPostData(email: emailId, password: paswrd)
        guard let jsonData = try? JSONEncoder().encode(postModel) else {return}
        
        var request = URLRequest(url:loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request){ data, response, error in
            if let data = data {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                     if(self.parseUserInfo(jsonObject)) {
                        if let accountInfo = response as? HTTPURLResponse {
                            self.xAcct = accountInfo.allHeaderFields["X-Acc"] as? String
                            print(self.xAcct)
                        }
                    }
                 }
                else {
                    print("JSON parse failed")
                    self.loginDelegate?.loginFailed(message: nil)
                }
            }
            else if let error = error {
                print("Request Failed \(error)")
                self.loginDelegate?.loginFailed(message: nil)
            }
        }.resume()
    }

    private func parseUserInfo(_ info:[String: Any])->Bool{
        guard let result: Int = info["result"] as? Int else {return false}
        if result == 0 {
            guard let msg: String = info["error_message"] as? String else {return false}
            self.loginDelegate?.loginFailed(message: msg)
            return false
        }
        
        guard  let userDataObj:[String: Any] = info["data"] as? [String: Any] else {return false}
        guard let userInfo = userDataObj["user"] as? [String: Any] else {return false}
        guard let usrId = userInfo["user_id"] as? Int else {return false}
        guard let createdDate = userInfo["created_at"] as? String else {return false}
        guard let name = userInfo["user_name"] as? String else {return false}
        guard let profileUrl = userInfo["user_profile_url"] as? String else {return false}

        let user = UserInfo(userId: usrId, userName: name, userProfileUrl: profileUrl, createdAt: createdDate)
        self.loginDelegate?.loginSuccess(userInfo: user)
        return true
    }
}
