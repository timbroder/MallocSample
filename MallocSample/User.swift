//
//  User.swift
//  MallocSample
//
//  Created by Tim Broder on 5/31/17.
//  Copyright © 2017 Kidfund. All rights reserved.
//

import Foundation
import RealmSwift

class UnsavedUser {
    dynamic var password: String?
    dynamic var photoId: Int = -1
    dynamic var ssn: String?
    dynamic var socialToken: String?
}

// Realm Model
class User: Object {
    dynamic var id: Int = -1
    dynamic var email: String?
    dynamic var firstName: String?
    dynamic var lastName: String?
    dynamic var facebookId: String?
    dynamic var instagramId: String?
    dynamic var photoUrl: String?
    dynamic var token: String?
    dynamic var fullUser = false
    dynamic var donationPercent: Int = 0

    // Extra info

    dynamic var birthday: Date?
    dynamic var phone: String?
    dynamic var address1: String?
    dynamic var address2: String?
    dynamic var zip: String?
    dynamic var city: String?
    dynamic var state: String?

    // User settings
    dynamic var allowNotification: Bool = true
}
