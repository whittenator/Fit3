//
//  SegmentedControl.swift
//  Fitness Challenge
//
//  Created by Travis Whitten on 6/2/17.
//  Copyright © 2017 Travis Whitten. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    var label1 = "Male"
    var label2 = "Female"
    
    var items: [String] = ["Male", "Female"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        
    }
    
    
    func setupView() {
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        layer.borderWidth = 1
        
        backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        
        setupLabels()
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels() {
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            let label = UILabel(frame: CGRect.zero)
            label.text = items[index - 1]
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = UIFont(name: "Avenir Next Bold", size: 20)
            self.addSubview(label)
            labels.append(label)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = UIColor.init(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.0)
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1 {
            let label = labels[index]
            
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRect(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
        }
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex: Int?
        for(index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            //print("Calculated Index: \(selectedIndex)")
            sendActions(for: .valueChanged)
        }
        return false
    }
    
    func displayNewSelectedIndex() {
        let label = labels[selectedIndex]
        self.thumbView.frame = label.frame
        
        
        
    }
    
    
    
}
