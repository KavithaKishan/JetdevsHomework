//
//  LoginModel.swift
//  JetDevsHomeWork
//
//  Created by Kavita Kishan on 06/12/22.
//

import Foundation

struct UserInfo: Codable{
    let userId: Int
    let userName: String
    let userProfileUrl: String
    let createdAt: String
}

struct LoginPostData: Codable {
    let email: String
    let password: String
}


