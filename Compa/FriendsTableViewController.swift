//
//  FriendsTableViewController.swift
//  Compa
//
//  Created by MacBook Pro on 5/3/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit
import FacebookCore

import Firebase

// TODO
// donation
// Thai Translation
// Language switching
// if no internet
// refactor


class FriendsTableViewController: UITableViewController, UISearchResultsUpdating, GADNativeAppInstallAdLoaderDelegate, GADNativeContentAdLoaderDelegate {
    
    //MARK: Properties
    //var friends = [Friend]()
    var friends = [AnyObject]()
    
    var nextPage: String?
    var loading = false
    var friendsFiltered = [Friend]()
    let searchController = UISearchController(searchResultsController: nil)
    
    /// The ad unit ID from the AdMob UI.
    let adUnitID = "ca-app-pub-3940256099942544/2247696110"
    
    /// The number of native ads to load.
    var numAdsToLoad = 5
    
    /// The native ads.
    var nativeAds = [GADNativeAd]()
    
    /// The ad loader that loads the native ads.
    var adLoader: GADAdLoader!
    
    /// The number of completed ad loads (success or failures).
    var numAdLoadCallbacks = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.searchController.searchResultsUpdater = self as UISearchResultsUpdating
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.searchController.searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        self.navigationItem.titleView = self.searchController.searchBar

        tableView.register(UINib(nibName: "NativeAppInstallAdCell", bundle: nil),
                           forCellReuseIdentifier: "NativeAppInstallAdCell")
        tableView.register(UINib(nibName: "NativeContentAdCell", bundle: nil),
                           forCellReuseIdentifier: "NativeContentAdCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyUtil.checkLoginAndNavigateToLogin(self)
        
        // Prepare the ad loader and start loading ads.
        adLoader = GADAdLoader(adUnitID: adUnitID,
                               rootViewController: self,
                               adTypes: [kGADAdLoaderAdTypeNativeAppInstall,
                                         kGADAdLoaderAdTypeNativeContent],
                               options: nil)
        adLoader.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if friends.count == 0 {
            //self.loadFriends("/me/friends?fields=id,name,birthday,picture,gender&limit=4")
            self.loadFriends("/me/friends?fields=id,name,birthday,picture,gender")
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
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.friendsFiltered.count
        } else {
            return self.friends.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell else {
                fatalError("Dequed cell failed")
            }
            let friend = friendsFiltered[indexPath.row] as Friend
            cell.friendName.text = friend.name
            cell.friendImage.downloadedFrom(link: friend.photoUrl!)
            cell.friendBirthday.text = friend.birthday
            return cell
            
        } else {
            if let friend = friends[indexPath.row] as? Friend {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell else {
                    fatalError("Dequed cell failed")
                }
                cell.friendName.text = friend.name
                cell.friendImage.downloadedFrom(link: friend.photoUrl!)
                cell.friendBirthday.text = friend.birthday
                return cell
            } else if let nativeAppInstallAd = friends[indexPath.row] as? GADNativeAppInstallAd {
                /// Set the native ad's rootViewController to the current view controller.
                nativeAppInstallAd.rootViewController = self
                
                let nativeAppInstallAdCell = tableView.dequeueReusableCell(
                    withIdentifier: "NativeAppInstallAdCell", for: indexPath)
                
                // Get the app install ad view from the Cell. The view hierarchy for this cell is defined in
                // NativeAppInstallAdCell.xib.
                let appInstallAdView = nativeAppInstallAdCell.subviews[0].subviews[0]
                    as! GADNativeAppInstallAdView
                
                // Associate the app install ad view with the app install ad object.
                // This is required to make the ad clickable.
                appInstallAdView.nativeAppInstallAd = nativeAppInstallAd
                
                // Populate the app install ad view with the app install ad assets.
                (appInstallAdView.headlineView as! UILabel).text = nativeAppInstallAd.headline
                (appInstallAdView.priceView as! UILabel).text = nativeAppInstallAd.price
                (appInstallAdView.starRatingView as! UILabel).text =
                    nativeAppInstallAd.starRating!.description + "\u{2605}"
                (appInstallAdView.bodyView as! UILabel).text = nativeAppInstallAd.body
                // The SDK automatically turns off user interaction for assets that are part of the ad, but
                // it is still good to be explicit.
                (appInstallAdView.callToActionView as! UIButton).isUserInteractionEnabled = false
                (appInstallAdView.callToActionView as! UIButton).setTitle(
                    nativeAppInstallAd.callToAction, for: UIControlState.normal)
                
                return nativeAppInstallAdCell
            } else {
                let nativeContentAd = friends[indexPath.row] as! GADNativeContentAd
                
                /// Set the native ad's rootViewController to the current view controller.
                nativeContentAd.rootViewController = self
                
                let nativeContentAdCell = tableView.dequeueReusableCell(
                    withIdentifier: "NativeContentAdCell", for: indexPath)
                
                // Get the content ad view from the Cell. The view hierarchy for this cell is defined in
                // NativeContentAdCell.xib.
                let contentAdView = nativeContentAdCell.subviews[0].subviews[0]
                    as! GADNativeContentAdView
                
                // Associate the content ad view with the content ad object.
                // This is required to make the ad clickable.
                contentAdView.nativeContentAd = nativeContentAd
                
                // Populate the content ad view with the content ad assets.
                (contentAdView.headlineView as! UILabel).text = nativeContentAd.headline
                (contentAdView.bodyView as! UILabel).text = nativeContentAd.body
                (contentAdView.advertiserView as! UILabel).text = nativeContentAd.advertiser
                // The SDK automatically turns off user interaction for assets that are part of the ad, but
                // it is still good to be explicit.
                (contentAdView.callToActionView as! UIButton).isUserInteractionEnabled = false
                (contentAdView.callToActionView as! UIButton).setTitle(
                    nativeContentAd.callToAction, for: UIControlState.normal)
                
                return nativeContentAdCell
            }
        }
        
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !searchController.isActive && searchController.searchBar.text == "" {
            if nextPage != nil {
                let offset = scrollView.contentOffset.y
                let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
                let diffOffset = maxOffset - offset
                if diffOffset <= 0 {
                    self.loadFriends(nextPage!)
                }
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
    
    // MARK: Action
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    

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
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedFriendCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            if searchController.isActive && searchController.searchBar.text != "" {
                calcResultVC.friend = friendsFiltered[indexPath.row]
            } else {
                calcResultVC.friend = friends[indexPath.row] as! Friend
            }
            
        default:
            break
        }
        
    }
    
    //MARK: Private Methods
    
    private func loadFriends(_ url: String) {
        
        if (!self.loading) {
            self.loading = true
            
            let connection = GraphRequestConnection()
            
            connection.add(FBGetRequest(url, nil))
            { response, result in
                switch result {
                case .success(let response):
                    
                    let respData = response.rawResponse as! NSDictionary
                    let respFriends = respData["data"] as! [NSDictionary]
                    if respData["paging"] != nil {
                        let respPage = respData["paging"] as! NSDictionary
                        
                        if respPage["next"] != nil {
                            let bufUrl = respPage["next"] as! String
                            let urlArr = bufUrl.characters.split(separator: "?").map(String.init)
                            self.nextPage = "/me/friends?" + urlArr[1]
                        } else {
                            self.nextPage = nil
                        }
                        
                    }
                    
                    var oldFriendsCount = self.friends.count
                    
                    for respFriend in respFriends {
                        
                        if respFriend["birthday"] == nil {
                            continue
                        }
                        
                        let id = respFriend["id"] as! String
                        let name = respFriend["name"] as! String
                        
                        let photoData = respFriend["picture"] as! NSDictionary
                        let photoUrl = photoData["data"] as! NSDictionary
                        let photo = photoUrl["url"] as! String
                        
                        let date = respFriend["birthday"] as! String
                        
                        let nsBirthday = MyUtil.convertFBDatetoDEfaultDate(date)
                        let birthdayStr = nsBirthday["birthdayStr"] as! String
                        let birthdayNSStr = nsBirthday["birthdayNSStr"] as! String
                        
                        let gender = respFriend["gender"] as! String
                        
                        guard let friend = Friend(id: id, name: name, photoUrl: photo, nsBirthday: MyUtil.nsDateFormat(birthdayNSStr), birthday: birthdayStr, gender: gender) else {
                            fatalError("something happened to friend1")
                        }
                        
                        self.friends.insert(friend, at: oldFriendsCount)
                        oldFriendsCount += 1
                        
                    }
                    
                    self.tableView.reloadData()
                    self.loading = false
                    
                    self.preloadNextAd()
                    
                case .failed(let error):
                    print("Custom Graph Request Failed: \(error)")
                }
            }
            connection.start()
            
        }
    
    }
    
    private func filterContentForSearchText(searchText: String, scope: String = "All") {
        friendsFiltered = friends.filter { friend in
            var resFlg:Bool = false
            if let buf = friend as? Friend {
                resFlg = buf.name.lowercased().contains(searchText.lowercased())
            }
            return  resFlg
        } as! [Friend]
        
        tableView.reloadData()
    }
    
    /// Preload native ads sequentially.
    func preloadNextAd() {
        numAdsToLoad = Int(floor(Double(friends.count / 5)));
        if numAdLoadCallbacks < numAdsToLoad {
            
            let request = GADRequest()
            if MyProfile.sharedInstance.nsBirthday != nil {
                request.birthday = MyProfile.sharedInstance.nsBirthday! as Date
                request.gender = MyProfile.sharedInstance.gender! == "male" ? .male : .female
            }
            
            adLoader.load(request)
        } else {
            addNativeAds()
        }
    }
    
    /// Add native ads to the tableViewItems list.
    func addNativeAds() {
        if nativeAds.count <= 0 {
            return
        }
        
        if (!self.loading) {
            self.loading = true
            let adInterval = (friends.count / nativeAds.count) + 1
            var index = 0
            for nativeAd in nativeAds {
                if index < friends.count {
                    if friends[index] is Friend {
                        friends.insert(nativeAd, at: index)
                    }
                    index += adInterval
                } else {
                    break
                }
            }
            self.tableView.reloadData()
            self.loading = false
        }
    }
    
    // MARK: - GADAdLoaderDelegate
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        
        // Increment the number of ad load callbacks.
        numAdLoadCallbacks += 1
        
        // Load the next native ad.
        preloadNextAd()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAppInstallAd: GADNativeAppInstallAd) {
        print("Received native app install ad: \(nativeAppInstallAd)")
        
        // Increment the number of ad load callbacks.
        numAdLoadCallbacks += 1
        
        // Add the native ad to the list of native ads.
        nativeAds.append(nativeAppInstallAd)
        
        // Load the next native ad.
        preloadNextAd()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADNativeContentAd) {
        print("Received native content ad: \(nativeContentAd)")
        
        // Increment the number of ad load callbacks.
        numAdLoadCallbacks += 1
        
        // Add the native ad to the list of native ads.
        nativeAds.append(nativeContentAd)
        
        // Load the next native ad.
        preloadNextAd()
    }

}


