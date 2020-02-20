//
//  Switch.swift
//  CustomSwitch
//
//  Created by Gagan Vishal on 2020/02/18.
//  Copyright © 2020 Gagan Vishal. All rights reserved.
//

import Foundation
import UIKit

class CustomSwitch: UIControl {
    /**
      On state tint color public propertis to access outside of the class
     */
    public var onTintColor = UIColor.blue {
        didSet {
            self.setupView()
        }
    }
    /**
      Off state tint color public propertis to access outside of the class
     */
    public var offTintColor = UIColor.red{
        didSet {
            self.setupView()
        }
    }
    /**
      Set corner radius of View
     */
    public var cornerRadius: CGFloat = 0.5 {
        didSet{
            self.layoutSubviews()
        }
    }
    /**
     Thumbnail tint color
     */
    public var thumbnailTintColor = UIColor.green {
        didSet {
            self.thumbnailView.backgroundColor =  self.thumbnailTintColor
        }
    }
    /**
           Thumbnail Corner radius
     */
    public var thumbnailCornerRadius:CGFloat = 0.5
    {
        didSet{
            self.layoutSubviews()
        }
    }
    /**
             thumbnail size
     */
    public var thumbnailSize = CGSize.zero
    {
        didSet{
            self.layoutSubviews()
        }
    }
    /**
            Thumbnail padding
     */
    public var padding: CGFloat = 1.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    /**
        Switch State
     */
    public var isOn: Bool = true
    /**
     Switch animation duration
     */
    public var animationDuration: CGFloat = 0.5
    
    ///Private properties
    /**
        Thumbnail view
     */
    private var thumbnailView = UIView(frame: .zero)
    /**
         Thumbnail switch on CGPoint
     */
    private var onPoint: CGPoint = .zero
    /**
        Thumbnail switch off point
     */
    private var offPoint: CGPoint = .zero
    /**
            Thumbnail animation state
     */
    private var isAnimating: Bool = false
    /**
        Smily & Sad emoji. Make public and allow  to reset these string
     */
    public let smilyFaceCode = "😁"
    public let sadFaceRmoji = "☹️"
    /**
            Labels to set below on Thumbnail view
     */
    
    private var backgroundOfflabel:UILabel = UILabel()
    private var backgroundOnlabel:UILabel = UILabel()
    /**
            Setup views when background views are visible
     */
    public var areBackgroundLabelsVisible: Bool = false {
        didSet {
            self.setupView()
        }
    }
    
    //MARK:- View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            //view ui setup
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            //thumbnail setup
            let thumbnailSize = self.thumbnailSize != .zero ? self.thumbnailSize : CGSize(width: self.bounds.size.width/2 + 2 , height: self.bounds.size.height - 2)
            let thumbnailYPosition = (self.bounds.size.height - thumbnailSize.height)/2
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbnailSize.width - self.padding, y: thumbnailYPosition)
            self.offPoint =  CGPoint(x: self.padding, y: thumbnailYPosition)
            self.thumbnailView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbnailSize)
            self.thumbnailView.layer.cornerRadius = self.thumbnailCornerRadius*self.thumbnailView.frame.size.height
        }
        if self.areBackgroundLabelsVisible {
            let labelWidth = self.bounds.width / 2 - self.padding * 2
            self.backgroundOnlabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
            self.backgroundOfflabel.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
        }
    }
    
    //MARK:- Remove all sybviews added on View
    private func clearView() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    //MARK:- View setup
    private func setupView() {
        //1. Remove all added views
        self.clearView()
        //2.
        self.clipsToBounds = true
        self.thumbnailView.backgroundColor = self.thumbnailTintColor
        self.thumbnailView.isUserInteractionEnabled = false
        self.addSubview(self.thumbnailView)
        //3. 2D effect
        self.thumbnailView.layer.shadowColor = UIColor.black.cgColor
        self.thumbnailView.layer.shadowRadius = 1.5
        self.thumbnailView.layer.shadowOpacity = 0.4
        self.thumbnailView.layer.shadowOffset = CGSize(width: 0.75, height: 2)
        //4.
        if areBackgroundLabelsVisible {
            setupLabels()
        }
    }
    
    //MARK:- Add Background labels under thumbnailView
    fileprivate func setupLabels() {
           guard self.areBackgroundLabelsVisible else {
               self.backgroundOfflabel.alpha = 0
               self.backgroundOnlabel.alpha = 0
               return
           }
           let labelWidth = self.bounds.width / 2 - self.padding * 2
           //On State for Switch
           self.backgroundOnlabel.alpha = 1
           self.backgroundOnlabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: self.frame.height)
           self.backgroundOnlabel.font = UIFont.systemFont(ofSize: 14)
           self.backgroundOnlabel.text = smilyFaceCode
           self.backgroundOnlabel.textAlignment = .center
           self.insertSubview(self.backgroundOnlabel, belowSubview: self.thumbnailView)
           //Off state for switch
           self.backgroundOfflabel.alpha = 1
           self.backgroundOfflabel.frame = CGRect(x: self.frame.width - labelWidth, y: 0, width: labelWidth, height: self.frame.height)
           self.backgroundOfflabel.font = UIFont.boldSystemFont(ofSize: 12)
           self.backgroundOfflabel.text = sadFaceRmoji
           self.backgroundOfflabel.textAlignment = .center
           self.insertSubview(self.backgroundOfflabel, belowSubview: self.thumbnailView)
       }
    
    //MARK:- Thumbnail View Animation
    private func animateView(){
        self.isOn = !self.isOn
        self.isAnimating = true
        UIView.animate(withDuration: TimeInterval(self.animationDuration), delay: 0.0, options: [.curveEaseOut,.beginFromCurrentState], animations: {
            self.thumbnailView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }) { _ in
            self.isAnimating = false
            self.sendActions(for: .valueChanged)
        }
    }
    
    //MARK:- UIControl Delegate
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        //1.
        animateView()
        //2.
        return true
    }
}
