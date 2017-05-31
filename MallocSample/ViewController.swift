//
//  ViewController.swift
//  MallocSample
//
//  Created by Tim Broder on 5/31/17.
//  Copyright © 2017 Kidfund. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm = KidRealm.realmForReading()
        if UserDataService.count(realm) == 0 {
            breadcrumbs.append("LoadingViewController.viewDidLoad \(currentUser.id) \(currentUser.token ?? "UNKNOWN TOKEN")")
        } else {
            breadcrumbs.append("LoadingViewController.viewDidLoad \(currentUser.id) \(currentUser.token ?? "UNKNOWN TOKEN")")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

