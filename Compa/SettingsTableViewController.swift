//
//  SettingsTableViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/17/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

import FacebookCore

import FBSDKShareKit

class SettingsTableViewController: UITableViewController {

    // MARK: Properties
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AccessToken.current != nil {
            self.loginSwitch.isOn = true
        } else {
            self.loginSwitch.isOn = false
        }
        self.loginSwitchText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Action
    
    @IBAction func loginSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            MyUtil.fbLogin(self) {()->() in
                self.loginSwitch.isOn = true
                self.loginSwitchText()
            }
        } else {
            MyUtil.fbLogout()
        }
        self.loginSwitchText()
    }
    
    @IBAction func appInviteButton(_ sender: Any) {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://test/myapplink")! as URL
        content.appInvitePreviewImageURL = NSURL(string: "https://test/myapplink")! as URL
        // Old Way, now depreciated :
        //FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
        //New way :
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self as FBSDKAppInviteDialogDelegate)
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: Private Function
    
    private func loginSwitchText() {
        if self.loginSwitch.isOn {
            self.loginLabel.text = NSLocalizedString("Logged In", comment: "Settings Logged In")
        } else {
            self.loginLabel.text = NSLocalizedString("Login with Facebook", comment: "Settings Login with Facebook")
        }
    }
    
    

}


extension SettingsTableViewController: FBSDKAppInviteDialogDelegate{
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        //println("Complete invite without error")
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        //println("Error in invite \(error)")
    }
}

