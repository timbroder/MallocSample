//
//  UserDataService.swift
//  MallocSample
//
//  Created by Tim Broder on 5/31/17.
//  Copyright © 2017 Kidfund. All rights reserved.
//

import Foundation
import Foundation
import RealmSwift

struct UserDataService{
    static func getCurrentUser(_ realm: ReadingRealm) -> User? {
        let getUser = realm.objects(User.self)
        if let user = getUser.first {
            return user
        }

        breadcrumbs.append("Getting empty currentUser \(UserDataService.count(realm))")

        return nil
    }

    static func count(_ realm: ReadingRealm) -> Int {
        return realm.objects(User.self).count
    }
}
