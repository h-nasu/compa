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
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton

        // Check Login Status
        MyUtil.checkLoginAndNavigateToFriends(self)
        
        // Make login button
        /*
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        */
        // Add a custom login button to your app
        let myLoginButton = UIButton(type: .custom)
        myLoginButton.backgroundColor = UIColor.blue
        //myLoginButton.frame = CGRect(0, 0, 180, 40)
        myLoginButton.frame = CGRect(origin: CGPoint(x:0,y:0), size: CGSize(width: 180, height: 40))
        myLoginButton.center = view.center
        myLoginButton.setTitle("Login with Facebook", for: .normal)
        
        // Handle clicks on the button
        //myLoginButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        
        // Add the button to the view
        view.addSubview(myLoginButton)
        
    }
    
    
    // Once the button is clicked, show the login dialog
    func loginButtonClicked() {
        MyUtil.fbLogin(self) { ()->() in
            MyUtil.checkLoginAndNavigateToFriends(self)
        };
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyUtil.checkLoginAndNavigateToFriends(self)
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
    

}
