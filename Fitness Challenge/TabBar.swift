//
//  TabBar.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/4/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit


class TabBar: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileController = UIViewController()
        profileController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        let nav1 = UINavigationController(rootViewController: profileController)
        
        let challengeController = UIViewController()
        let nav2 = UINavigationController(rootViewController: challengeController)
        
        let createChallenges = UIViewController()
        createChallenges.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 3)
        let nav3 = UINavigationController(rootViewController: createChallenges)
        
        viewControllers = [nav1, nav2, nav3]
        setupMiddleButton()
        
        
        
    }
    
    func setupMiddleButton() {
        
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "Signout"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
        
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 1
    }
    
    
}

