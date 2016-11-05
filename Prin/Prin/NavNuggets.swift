//
//  NavNuggets.swift
//  Prin
//
//  Created by Kristofer Younger on 11/5/16.
//  Copyright © 2016 Tioga Digital. All rights reserved.
//

import Foundation
import RealmSwift


class NavNuggets: Object {
    dynamic var label = ""
    dynamic var descr = ""
    dynamic var order = 1
    dynamic var segueName = "segue"
    dynamic var thumbnailData: Data? = nil
    
    var thumbnail: UIImage? {
        get {
            if thumbnailData == nil {
                return UIImageView.fontAwesomeAsImage("fa-question", size: 28.0, color: AppPrimary )
            }
            return UIImage(data: thumbnailData!)
        }
        set(newImage) {
            thumbnailData = UIImagePNGRepresentation(newImage!)
        }
    }

    convenience init(label: String, description: String, order: Int, segue: String, thumbnail: UIImage) {
        self.init()
        self.label = label
        self.descr = description
        self.order = order
        self.segueName = segue
        self.thumbnail = thumbnail
    }
// Specify properties to ignore (Realm won't persist these)
    
  override static func ignoredProperties() -> [String] {
    return ["thumbnail"]
  }

    

}

func createNavigation() {
    let shareIcon = UIImageView.fontAwesomeAsImage("fa-share-square-o", size: 28.0, color: AppPrimary )
    let recvIcon = UIImageView.fontAwesomeAsImage("fa-cloud-download", size: 28.0, color: AppPrimary )
    let profIcon = UIImageView.fontAwesomeAsImage("fa-users", size: 28.0, color: AppPrimary )
    let iceIcon = UIImageView.fontAwesomeAsImage("fa-ambulance", size: 28.0, color: AppPrimary )
    
    let realm = try! Realm()
    
    try! realm.write {
        realm.delete((realm.objects(NavNuggets.self)))
        
        realm.add(NavNuggets(label: "Share...", description: "share your personal info with doctor", order: 1,
                             segue: "shareProcessSegue", thumbnail: shareIcon))
        realm.add(NavNuggets(label: "Receive...", description: "take some data from your doctor", order: 2, segue: "takeProcessSegue", thumbnail: recvIcon))
        realm.add(NavNuggets(label: "Profiles", description: "you and the people you care for", order: 3, segue: "displayProfilesSegue", thumbnail: profIcon))
        realm.add(NavNuggets(label: "In Case of Emergency", description: "urgent care information about you or the people you care for", order: 4, segue: "iceSegue", thumbnail: iceIcon))
    }
}

let shareProcessSegue = "shareProcessSegue"
let takeProcessSegue = "takeProcessSegue"
let displayProfilesSegue = "displayProfilesSegue"
let iceSegue = "iceSegue"
