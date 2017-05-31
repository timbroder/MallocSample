//
//  Constants.swift
//  MallocSample
//
//  Created by Tim Broder on 5/31/17.
//  Copyright © 2017 Kidfund. All rights reserved.
//

import Foundation

var breadcrumbs = [String]()

var currentUser: User {
    get {
        let realm = KidRealm.realmForReading()
        if let user = UserDataService.getCurrentUser(realm) {
            return user
        }

        breadcrumbs.append("Getting empty currentUser")
        return User()
    }
}

