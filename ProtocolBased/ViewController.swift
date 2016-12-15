//
//  ViewController.swift
//  ProtocolBased
//
//  Created by Guanxiong Cao  on 15/12/2016.
//  Copyright © 2016 Guanxiong Cao . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let request = UserRequest(name: "onevcat")
        request.send {
            user in
            if let user = user {
                print("\(user.message) from \(user.name)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

