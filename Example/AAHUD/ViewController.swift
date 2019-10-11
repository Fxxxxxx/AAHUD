//
//  ViewController.swift
//  AAHUD
//
//  Created by Aaron on 07/19/2019.
//  Copyright (c) 2019 Aaron. All rights reserved.
//

import UIKit
import AAHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func show(_ sender: Any) {
        HUD.showSuccess("show the hud")
//        HUD.showLoading(message: "load......")
    }
    
}

