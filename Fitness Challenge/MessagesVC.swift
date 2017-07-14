//
//  MessagesVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/16/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds



class MessagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var messageTV: UITableView!
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _refHandle2: DatabaseHandle!
    var messages: [DataSnapshot]! = []
    var msgLength: NSNumber = 10
    var userName: String = ""
    var profileURL: String = ""
    //var userID: String = ""
    var calendar = Calendar.current
    var date = Date()
    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var sendBtn: UIButton!
    var ref: DatabaseReference!
    
    private var _userKey: Leaderboard!
    private var _userID: Messages!
    var stringUserName = ""
    
    
    var userKey: Leaderboard {
        get {
            return _userKey
        } set {
            _userKey = newValue
        }
    }
    
    var userID: Messages {
        get {
            return _userID
        } set {
            _userID = newValue
        }
    }

    
   let kBannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func didSendMessage(_ sender: Any) {
        
        _ = textFieldShouldReturn(textField)
    }
    
    
    @IBAction func backToMessages(_ sender: Any) {
        performSegue(withIdentifier: "backToMessages", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTV.dataSource = self
        messageTV.delegate = self
        
        configureDatabase()
        loadAd()
        
        
        let currentUser = Auth.auth().currentUser!.uid
        //Getting the SENDER's profile information
        DataService.ds.REF_USERS.child(currentUser).child("profile").observeSingleEvent(of: .value, with: {(snap) in
                    //print("\(snap)")
                    self.userName = snap.childSnapshot(forPath: "userName").value as! String
                    //print("USER: \(self.userName)")
                    self.profileURL = snap.childSnapshot(forPath: "profileImg").value as! String
            
        })
        
        // Getting the RECEIVER's profile information
        DataService.ds.REF_USERS.child(self.userID.userID).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.stringUserName = snapshot.childSnapshot(forPath: "userName").value as! String
            //print("USER SELECTED: \(self.stringUserName)")
            self.title = "\(self.stringUserName)"
            
        })

       
        
    }
     let currentUser = Auth.auth().currentUser!.uid
    deinit {
        //Senders reference handle
        if let refHandle = _refHandle {
            DataService.ds.REF_USER_CURRENT.child("messages").child(self.userID.userID).removeObserver(withHandle: refHandle)
        }
        //Receivers reference handle
        if let refHandle2 = _refHandle2 {
            self.ref.child(self.userID.userID).child("messages").child(currentUser).removeObserver(withHandle: refHandle2)
        }
    }
    
    func configureDatabase() {
        let currentUser = Auth.auth().currentUser!.uid
        ref = Database.database().reference()
        _refHandle2 = self.ref.child("users").child(self.userID.userID).child("messages").child(currentUser).observe(.childAdded, with: {[weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.messageTV.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return true}
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= self.msgLength.intValue //Bool
    }
    
    // UITextViewDelegate protocol methods
    
    
    func sendMessage(withData data: [String: String]) {
        let currentUser = Auth.auth().currentUser!.uid
        var mdata = data
        mdata["username"] = self.userName
        mdata["userID"] = self.currentUser
        let photoURL = self.profileURL
            mdata["photoURL"] = photoURL
        let timeStamp = NSDate().timeIntervalSince1970
        
        //Time since message
        let stampTimeDate = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM d, hh:mm a")
        
        let stringDate = df.string(from: stampTimeDate)
        
        
        
        mdata["timeStamp"] = "\(stringDate)"
        
        // Push data to Firebase Database
        self.ref.child("users").child(self.userID.userID).child("messages").child(currentUser).childByAutoId().setValue(mdata)
        self.ref.child("users").child(currentUser).child("messages").child(self.userID.userID).childByAutoId().setValue(mdata)
    }
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellTableViewCell") as? MessageCellTableViewCell
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String: String] else { return cell! }
        let userName = message["username"] ?? ""
        let text = message["text"] ?? ""
        let time = message["timeStamp"] ?? ""
        cell?.userMessage?.text = userName + ": " + text
        cell?.sentTime?.text = time
        cell?.profileImg?.image = UIImage(named: "Profile")
        if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
            let data = try? Data(contentsOf: URL) {
            cell?.profileImg?.image = UIImage(data: data)
            
            

        }
        
        return cell!
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        textField.text = ""
        view.endEditing(true)
        let data = [Constants.MessageFields.text: text]
        sendMessage(withData: data)
        return true
    }
    
    func loadAd() {
        self.banner.adUnitID = kBannerAdUnitID
        self.banner.rootViewController = self
        self.banner.load(GADRequest())
    }

    
}
