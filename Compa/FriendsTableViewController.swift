//
//  FriendsTableViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    //MARK: Properties
    var friends = [Friend]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: false)
        //self.navigationItem.setHidesBackButton(true, animated:true);
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        self.loadSampleFriends()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell else {
            fatalError("Dequed cell failed")
        }
        let friend = friends[indexPath.row]
        cell.friendName.text = friend.name
        cell.friendImage.image = friend.photo
        cell.friendBirthday.text = friend.birthday

        return cell
    }
    

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowCompaFriendList":
            guard let calcResultVC = segue.destination as? CalcResultViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedFriendCell = sender as? FriendTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedFriendCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            calcResultVC.friend = friends[indexPath.row]
        default:
            break
        }
        
    }
    
    //MARK: Private Methods
    
    private func loadSampleFriends() {
        let testImage = UIImage(named: "defaultPhoto")
        guard let friend1 = Friend(name: "Fafa", photo: testImage, nsBirthday: MyUtil.nsDateFormat("1982-10-06"), birthday: "1982-10-06") else {
            fatalError("something happened to friend1")
        }
        guard let friend2 = Friend(name: "Gege", photo: testImage, nsBirthday: MyUtil.nsDateFormat("1988-12-04"), birthday: "1988-12-04") else {
            fatalError("something happened to friend2")
        }
        guard let friend3 = Friend(name: "Lolo", photo: testImage, nsBirthday: MyUtil.nsDateFormat("1981-09-17"), birthday: "1981-09-17") else {
            fatalError("something happened to friend3")
        }
        friends += [friend1, friend2, friend3]
    }

}
