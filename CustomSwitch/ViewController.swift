//
//  ViewController.swift
//  CustomSwitch
//
//  Created by Gagan Vishal on 2020/02/18.
//  Copyright © 2020 Gagan Vishal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let width: CGFloat = 90
    let height: CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                /*
         Here use stackview or any cusotm view where you want to add Switch
          */
        //1.
        let customSwitch = CustomSwitch(frame: CGRect(x: self.view.center.x, y: self.view.center.y - 100.0, width: width, height: height))
        customSwitch.areBackgroundLabelsVisible = true
        self.view.addSubview(customSwitch)
        //2.
        let customSwitchSecond = CustomSwitch(frame: CGRect(x: self.view.center.x, y: self.view.center.y - height/2 , width: width, height: height))
        customSwitchSecond.cornerRadius = 0.0
        customSwitchSecond.thumbnailCornerRadius = 0.1
        self.view.addSubview(customSwitchSecond)
        //3.
        let customSwitchThird = CustomSwitch(frame: CGRect(x: self.view.center.x, y: self.view.center.y + 100 , width: width, height: height))
        customSwitchThird.cornerRadius = 0.1
        customSwitchThird.clipsToBounds = false
        customSwitchThird.thumbnailSize = CGSize(width: customSwitchThird.frame.height  , height: customSwitchThird.frame.height + 10.0)
        customSwitchThird.thumbnailCornerRadius = 0.1
        customSwitchThird.addTarget(self, action: #selector(valueChaned), for: .valueChanged)
        self.view.addSubview(customSwitchThird)

    }


    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
    }
    
    //MARK:- Value changed action
    @objc func valueChaned(sender: CustomSwitch) {
        print("Value changed :\(sender.isOn)")
    }
}

