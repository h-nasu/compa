//
//  LoginViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check Login Status
        self.checkLoginAndNavigate()
        
        // Make login button
        /*
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        */
        // Add a custom login button to your app
        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor.darkGray
        //myLoginButton.frame = CGRect(0, 0, 180, 40)
        myLoginButton.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 180, height: 40))
        myLoginButton.center = view.center
        myLoginButton.setTitle("Login", for: .normal)
        
        // Handle clicks on the button
        //myLoginButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)
        
    }
    
    // Once the button is clicked, show the login dialog
    func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .userFriends, .custom("user_birthday") ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                let connection = GraphRequestConnection()
                connection.add(FBGetRequest(nil, nil)) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        print("Graph Request Succeeded: \(response)")
                        
                        // Get Logged in User Data
                        let respProfile = response.rawResponse as! NSDictionary
                        MyProfile.sharedInstance.id = respProfile["id"] as? String
                        MyProfile.sharedInstance.name = respProfile["name"] as? String
                        
                        let photoData = respProfile["picture"] as? NSDictionary
                        let photoUrl = photoData?["data"] as? NSDictionary
                        MyProfile.sharedInstance.photoUrl = photoUrl?["url"] as? String
                        
                        let date = respProfile["birthday"] as? String
                        let nsBirthday = MyUtil.convertFBDatetoDEfaultDate(date!)
                        MyProfile.sharedInstance.birthday = nsBirthday["birthdayStr"] as? String
                        MyProfile.sharedInstance.nsBirthday = MyUtil.nsDateFormat((nsBirthday["birthdayNSStr"] as? String)!)
                        
                        // Navigate
                        self.checkLoginAndNavigate()
                        
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Function
    
    private func checkLoginAndNavigate() {
        if let accessToken = AccessToken.current {
            let FriendsTableVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendsTableViewController") as? FriendsTableViewController
            self.navigationController?.pushViewController(FriendsTableVC!, animated: true)
        }
    }

}
