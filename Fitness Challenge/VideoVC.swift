//
//  VideoVC.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 1/3/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase


class VideoVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var wrongRep = "Wrong Rep Value"
    var vulgar = "Vulgar Content"
    var other = "Other"
    
    
    private var _videoLink: Leaderboard!
    private var _userKey: Leaderboard!
    private var _challengeKey: Leaderboard!
    

    
    var userKey: Leaderboard {
        get {
            return _userKey
        } set {
            _userKey = newValue
        }
    }
    
    var videoLink: Leaderboard {
        get {
            return _videoLink
        } set {
            _videoLink = newValue
        }
    }
    
    var challengeKey: Leaderboard {
        get {
            return _challengeKey
        } set {
            _challengeKey = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Report", style: .plain, target: self, action: #selector(reportTapped))
        self.title = "User"
        //webView.loadHTMLString(videoLink.videoLink, baseURL: nil)
        // Do any additional setup after loading the view.
    }
    
    //TODO: Send notification to myself and admin who created challenge
    //Popup menu that asks user why they are reporting
    func reportTapped() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let currentUser = Auth.auth().currentUser!.uid
        
        // Restyle the view of the Alert
        alert.view.tintColor = UIColor.white  // change text color of the buttons
        alert.view.backgroundColor = UIColor.black  // change background color
        alert.view.layer.cornerRadius = 25   // change corner radius
        
        
        // Change font of the title and message
        let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "AmericanTypewriter", size: 18)! ]
        let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
        let attributedTitle = NSMutableAttributedString(string: "Report", attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: "Select an Action", attributes: messageFont)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let action1 = UIAlertAction(title: self.vulgar, style: .default, handler: { (action) -> Void in
            print("Vulgar Content selected!")
            let alertController1 = UIAlertController(title: self.vulgar, message:"Are you sure?", preferredStyle: .alert)
            let yesAction1 = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                
            }
            let noAction1 = UIAlertAction(title: "No", style: .default) { (action: UIAlertAction) in
            }
            alertController1.addAction(yesAction1)
            alertController1.addAction(noAction1)
            self.present(alertController1, animated: true, completion: nil)
            DataService.ds.REF_REPORTS.child(self.challengeKey.challengeKey).child(self.userKey.userKey).child(currentUser).setValue(["Type": self.vulgar, "challengeKey": self.challengeKey.challengeKey, "videoLink": self.videoLink.videoLink])
            //DataService.ds.createReporter(challengeKey: self.challengeKey.challengeKey, uid: self.userKey.userKey,reporter: currentUser ,reportData: ["Type": self.vulgar, "videoLink": self.videoLink.videoLink])
            
        })
        
        let action2 = UIAlertAction(title: self.wrongRep, style: .default, handler: { (action) -> Void in
            print("Wrong Rep Value selected!")
            let alertController1 = UIAlertController(title: self.wrongRep, message:"Are you sure?", preferredStyle: .alert)
            let yesAction1 = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                
            }
            let noAction1 = UIAlertAction(title: "No", style: .default) { (action: UIAlertAction) in
            }
            alertController1.addAction(yesAction1)
            alertController1.addAction(noAction1)
            self.present(alertController1, animated: true, completion: nil)
            DataService.ds.REF_REPORTS.child(self.challengeKey.challengeKey).child(self.userKey.userKey).child(currentUser).setValue(["Type": self.wrongRep, "challengeKey": self.challengeKey.challengeKey, "videoLink": self.videoLink.videoLink])
            //DataService.ds.createReporter(challengeKey: self.challengeKey.challengeKey, uid: self.userKey.userKey,reporter: currentUser ,reportData: ["Type": self.wrongRep, "videoLink": self.videoLink.videoLink])
        })
        
        let action3 = UIAlertAction(title: self.other, style: .default, handler: { (action) -> Void in
            let alert2 = UIAlertController(title: "Other", message: "What did they do?", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                if let field = alert2.textFields?[0] {
                    // store your data
                    let alertController1 = UIAlertController(title: "OTHER", message:"Are you sure?", preferredStyle: .alert)
                    let yesAction1 = UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
                        
                    }
                    let noAction1 = UIAlertAction(title: "No", style: .default) { (action: UIAlertAction) in
                    }
                    alertController1.addAction(yesAction1)
                    alertController1.addAction(noAction1)
                    self.present(alertController1, animated: true, completion: nil)
                    DataService.ds.REF_REPORTS.child(self.challengeKey.challengeKey).child(self.userKey.userKey).child(currentUser).setValue(["Type": field.text!, "challengeKey": self.challengeKey.challengeKey, "videoLink": self.videoLink.videoLink])
                    //print("\(field)")
                } else {
                    // user did not fill field
                    
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            alert2.addTextField { (textField) in
                textField.placeholder = "What happened?"
            }
            
            alert2.addAction(confirmAction)
            alert2.addAction(cancelAction)
            
            self.present(alert2, animated: true, completion: nil)
        })
        
       
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        
        // Add action buttons and present the Alert
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
      
        
    }

    override func viewDidAppear(_ animated: Bool) {
        let videoURL = NSURL(string: videoLink.videoLink)
        let player = AVPlayer(url: videoURL! as URL)
        let av = AVPlayerViewController()
        av.player = player
        av.view.frame = self.view.bounds
        self.addChildViewController(av)
        self.view.addSubview(av.view)
        av.didMove(toParentViewController: self)
        //let playerLayer = AVPlayerLayer(player: player)
        //playerLayer.frame = self.view.bounds
        //self.view.layer.addSublayer(playerLayer)
        
        //player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let videoURL = NSURL(string: videoLink.videoLink)
        let player = AVPlayer(url: videoURL! as URL)
        player.pause()
    }
    
    
    
    

}
