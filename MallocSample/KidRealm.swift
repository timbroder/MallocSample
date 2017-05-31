//
//  KidRealm.swift
//  MallocSample
//
//  Created by Tim Broder on 5/31/17.
//  Copyright © 2017 Kidfund. All rights reserved.
//

import Foundation
import RealmSwift
import Security


protocol ReadingRealm {
    func objects<T: Object>(_ type: T.Type) -> Results<T>
    func object<T: Object, K>(ofType type: T.Type, forPrimaryKey key: K) -> T?
    func resolve<Confined: ThreadConfined>(_ reference: ThreadSafeReference<Confined>) -> Confined?
    var isEmpty: Bool { get }
}
extension Realm: ReadingRealm {}

enum KidRealm {
    private static let sharedConfiguration = Realm.Configuration(
        encryptionKey: Key.generate(),
        schemaVersion: KidRealm.Migration.currentSchemaVersion,
        migrationBlock: KidRealm.Migration.executeAll
    )

    static func check() -> Bool {
        if let _ = try? Realm(configuration: sharedConfiguration) {
            return true
        } else {
            return false
        }
    }

    static func realmForReading() -> ReadingRealm {
        return getRealm()
    }

    private static func getRealm() -> Realm {
        return try! Realm(configuration: KidRealm.sharedConfiguration)
    }

    private enum Key {
        static func generate() -> Data {
            // Identifier for our keychain entry - should be unique for your application
            let keychainIdentifier = "com.kidfund.kidfund1.keychain"
            let keychainIdentifierData = keychainIdentifier.data(using: .utf8)!

            // First check in the keychain for an existing key
            var query: [NSString: AnyObject] = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecReturnData: true as AnyObject,
                kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
            ]

            // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
            // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
            var dataTypeRef: AnyObject?
            var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
            if status == errSecSuccess {
                return dataTypeRef as! Data
            } else {
                let msg = "Failed getting realm key with status: \(status) so retrying with delay"
                breadcrumbs.append(msg)
//                keyChainIssues(msg, prepend: "KEYCHAIN")

                // see here for why this sleep exists
                // https://openradar.appspot.com/27844971
                // https://forums.developer.apple.com/thread/4743#126088
                sleep(1)
                status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }

                if status == errSecSuccess {
                    return dataTypeRef as! Data
                } else {
                    let msg = "Failed getting realm key on retry with status: \(status)"
                    breadcrumbs.append(msg)
//                    keyChainIssues(msg, prepend: "KEYCHAIN")
                }
            }

            // No pre-existing key from this application, so generate a new one
            let keyData = NSMutableData(length: 64)!
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, keyData.mutableBytes.bindMemory(to: UInt8.self, capacity: 64)) //FLAG
            assert(result == 0, "Failed to get random bytes")

            // Store the key in the keychain
            query = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecValueData: keyData,
                kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
            ]

            status = SecItemAdd(query as CFDictionary, nil)

            if status == errSecSuccess {
                return keyData as Data
            } else {
                let msg = "Failed to insert the new key in the keychain: \(status)"
                breadcrumbs.append(msg)
//                keyChainIssues(msg, prepend: "KEYCHAIN")

                // see here for why this sleep exists
                // https://openradar.appspot.com/27844971
                // https://forums.developer.apple.com/thread/4743#126088

                sleep(1)

                status = SecItemAdd(query as CFDictionary, nil)

                if status == errSecSuccess {
                    return keyData as Data
                } else {
                    fatalError(msg)
                }
            }
        }
    }
}

extension KidRealm {
    enum Migration: UInt64 {
        // Keep track of what each migration does
        case addFollowersToChild = 1
        case addLikedByToPosts = 2

        static let currentSchemaVersion = Migration.addLikedByToPosts.rawValue

        static func executeAll(migration: RealmSwift.Migration, oldSchemaVersion: UInt64) {
            for value in 1...currentSchemaVersion {
                KidRealm.Migration(rawValue: value)?.execute(migration: migration, oldSchemaVersion: oldSchemaVersion)
            }
        }

        private func execute(migration: RealmSwift.Migration, oldSchemaVersion: UInt64) {
            guard oldSchemaVersion < rawValue else {
                return
            }
            switch self {
            case .addFollowersToChild:
                // No explicit migration needed
                break
            case .addLikedByToPosts:
                // No explicit migration needed
                break
            }
        }
    }
}
