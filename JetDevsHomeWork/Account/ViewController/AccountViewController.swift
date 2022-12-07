//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

protocol UserInfoDelegate:AnyObject{
    func setUserInfo(userInfo: UserInfo)
}

class AccountViewController: UIViewController,UserInfoDelegate {

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
    
    private var userAccountInfo:UserInfo?
    
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
		nonLoginView.isHidden = false
		loginView.isHidden = true
    }
	
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userAcct = self.userAccountInfo else {return}
        setProfileImage()
        nameLabel.text = userAcct.userName
         let days = getDaysFromDate(dateString: userAcct.createdAt)
        daysLabel.text = days > 1 ? "Created \(days) days ago" : "Created \(days) day ago"
    }
    
	@IBAction func loginButtonTap(_ sender: UIButton) {
        let loginViewController = LoginViewController.init(nibName: "LoginViewController", bundle: nil)
        loginViewController.delegate = self
        self.navigationController?.pushViewController(loginViewController, animated: true)
	}
	
    func setUserInfo(userInfo: UserInfo){
        nonLoginView.isHidden = true
        loginView.isHidden = false
        self.userAccountInfo = userInfo
    }

    func setProfileImage(){
        guard let profileUrl =  URL(string: userAccountInfo?.userProfileUrl ?? "") else {return}
        let resource = ImageResource(downloadURL: profileUrl)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
                case .success(let value):
                    self.headImageView.image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                    self.headImageView.image = UIImage(named: "Avatar")
            }
        }
    }
    
    func getDaysFromDate(dateString:String)->Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: dateString)
        guard let date = date else { return 0 }
        let now = Date()
        let days =  Calendar.current.dateComponents([.day], from: date, to: now).day ?? 0
        return days
    }
}
