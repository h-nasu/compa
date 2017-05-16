//
//  FriendsTableViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit
import FacebookCore

// TODO Search Friends
// Logout Share
// images
// translate
// if no internet


class FriendsTableViewController: UITableViewController {
    
    //MARK: Properties
    var friends = [Friend]()
    var nextPage: String?
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: false)
        //self.navigationItem.setHidesBackButton(true, animated:true);
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        //self.loadSampleFriends()
        
        //MyUtil.checkLoginAndNavigateToLogin(self)
        //self.loadFriends("/me/friends?fields=id,name,birthday,picture&limit=5")
 

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyUtil.checkLoginAndNavigateToLogin(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if friends.count == 0 {
            self.loadFriends("/me/friends?fields=id,name,birthday,picture&limit=5")
        }
        
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
        
        // imageView.downloadedFrom(link: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
        //cell.friendImage.image = friend.photo
        cell.friendImage.downloadedFrom(link: friend.photoUrl!)
        
        cell.friendBirthday.text = friend.birthday

        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if nextPage != nil {
            let offset = scrollView.contentOffset.y
            let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let diffOffset = maxOffset - offset
            if diffOffset <= 0 {
                self.loadFriends(nextPage!)
            }
        }
        
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
        //let testImage = UIImage(named: "defaultPhoto")
        let testImage = "https://scontent.xx.fbcdn.net/v/t1.0-1/c0.9.50.50/p50x50/10171803_10203680803685727_1619338145_n.jpg?oh=69e670f70ecdcf9b8584cf4350266808&oe=59BB72E4"
        guard let friend1 = Friend(id: "dfaaefa", name: "Fafa", photoUrl: testImage, nsBirthday: MyUtil.nsDateFormat("1982-10-06"), birthday: "1982-10-06") else {
            fatalError("something happened to friend1")
        }
        guard let friend2 = Friend(id: "dfadfaea", name: "Gege", photoUrl: testImage, nsBirthday: MyUtil.nsDateFormat("1988-12-04"), birthday: "1988-12-04") else {
            fatalError("something happened to friend2")
        }
        guard let friend3 = Friend(id: "khjijll", name: "Lolo", photoUrl: testImage, nsBirthday: MyUtil.nsDateFormat("1981-09-17"), birthday: "1981-09-17") else {
            fatalError("something happened to friend3")
        }
        friends += [friend1, friend2, friend3]
    }
    
    private func loadFriends(_ url: String) {
        
        if (!self.loading) {
            self.loading = true
            
            let connection = GraphRequestConnection()
            
            // For Testing
            connection.add(FBGetRequest(url, nil))
                //connection.add(FBGetRequest("/" + MyProfile.sharedInstance.id! + "/friends", ["fields": "id, name, birthday, picture", "limit":"5"]))
                //connection.add(FBGetRequest("/" + MyProfile.sharedInstance.id! + "/friends", nil))
            { response, result in
                switch result {
                case .success(let response):
                    
                    //print("Custom Graph Request Succeeded: \(response)")
                    //print("Check Raw Response Data: \(response.rawResponse)")
                    
                    let respData = response.rawResponse as! NSDictionary
                    let respFriends = respData["data"] as! [NSDictionary]
                    if respData["paging"] != nil {
                        let respPage = respData["paging"] as! NSDictionary
                        
                        if respPage["next"] != nil {
                            let bufUrl = respPage["next"] as! String
                            let urlArr = bufUrl.characters.split(separator: "?").map(String.init)
                            //self.nextPage = "/me/friends?limit=5&" + urlArr[1]
                            self.nextPage = "/me/friends?" + urlArr[1]
                        } else {
                            self.nextPage = nil
                        }
                        
                    }
                    
                    
                    //print("Get Friends List: \(respFriends)")
                    
                    let oldFriendsCount = self.friends.count
                    
                    for respFriend in respFriends {
                        
                        if respFriend["birthday"] == nil {
                            continue
                        }
                        
                        //print("Friend: \(respFriend)")
                        
                        let id = respFriend["id"] as! String
                        let name = respFriend["name"] as! String
                        
                        let photoData = respFriend["picture"] as! NSDictionary
                        let photoUrl = photoData["data"] as! NSDictionary
                        let photo = photoUrl["url"] as! String
                        
                        let date = respFriend["birthday"] as! String
                        
                        let nsBirthday = MyUtil.convertFBDatetoDEfaultDate(date)
                        let birthdayStr = nsBirthday["birthdayStr"] as! String
                        let birthdayNSStr = nsBirthday["birthdayNSStr"] as! String
                        
                        guard let friend = Friend(id: id, name: name, photoUrl: photo, nsBirthday: MyUtil.nsDateFormat(birthdayNSStr), birthday: birthdayStr) else {
                            fatalError("something happened to friend1")
                        }
                        self.friends.append(friend)
                        
                    }
                    
                    if self.friends.count != oldFriendsCount {
                        let newFriendsCount = self.friends.count - oldFriendsCount
                        let tableV = self.tableView
                        tableV?.beginUpdates()
                        for i in 0 ..< newFriendsCount {
                            tableV?.insertRows(at: [IndexPath(row: oldFriendsCount+i, section: 0)], with: .automatic)
                        }
                        tableV?.endUpdates()
                    }
                    
                    self.loading = false
                    
                case .failed(let error):
                    print("Custom Graph Request Failed: \(error)")
                }
            }
            connection.start()
            
        }
    
    }

}
