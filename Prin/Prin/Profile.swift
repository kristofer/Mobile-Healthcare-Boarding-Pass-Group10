//
//  Profile.swift
//  Prin
//
//  Created by Kristofer Younger on 11/5/16.
//  Copyright © 2016 Tioga Digital. All rights reserved.
//

import Foundation
import RealmSwift

class Profile: Object {
    dynamic var firstname = ""
    dynamic var lastname = ""
    dynamic var relation = ""
    dynamic var demos: Demos?
    dynamic var insurance: Insurance?
    let medications = List<Med>()
    let allergies = List<Allergy>()
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
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    func name() -> String {
        return "\(self.firstname) \(self.lastname)"
    }
}

class Demos: Object {
    dynamic var gender = ""
    dynamic var eyecolor = ""
    dynamic var bloodtype = ""
    dynamic var weight = 125.0
    dynamic var height = 68.0
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
class Insurance: Object {
    dynamic var carrier = ""
    dynamic var groupname = ""
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
class Med: Object {
    dynamic var name = ""
    dynamic var dosage = ""
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
class Allergy: Object {
    dynamic var name = ""
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    convenience init(something: String ) {
        self.init()
        self.name = something
    }
}

func createProfiles() {
    let realm = try! Realm()
    
    
    let me = Profile()
    me.firstname = "Alison"
    me.lastname = "Walker"
    me.demos = Demos()
    me.demos?.bloodtype = "B+"
    me.demos?.eyecolor = "blue"
    me.demos?.gender = "Female"
    
    me.insurance = Insurance()
    me.insurance?.carrier = "Etna"
    me.insurance?.groupname = "XP-1234-H-870"
    
    me.allergies.append(Allergy(something: "Wallflowers"))

    let billy = Profile()
    billy.firstname = "Billy"
    billy.lastname = "Walker"
    billy.relation = "Son"
    billy.demos = Demos()
    billy.demos?.bloodtype = "O+"
    billy.demos?.eyecolor = "blue"
    billy.demos?.gender = "Male"
    
    billy.insurance = Insurance()
    billy.insurance?.carrier = "Etna"
    billy.insurance?.groupname = "XP-1234-H-870"
    
    billy.allergies.append(Allergy(something: "Peanuts"))

    let mom = Profile()
    mom.firstname = "Margaret"
    mom.lastname = "Gerson"
    mom.relation = "Mother"
    
    mom.demos = Demos()
    mom.demos?.bloodtype = "O+"
    mom.demos?.eyecolor = "brown"
    mom.demos?.gender = "Female"
    
    mom.insurance = Insurance()
    mom.insurance?.carrier = "Regressive Insurance"
    mom.insurance?.groupname = "XP-HG76-M-123"
    
    mom.allergies.append(Allergy(something: "Aspirin"))
    mom.allergies.append(Allergy(something: "Green Tea"))
    
    try! realm.write {
        realm.delete((realm.objects(Profile.self)))
        realm.add(me)
        realm.add(billy)
        realm.add(mom)
    }
}


class Provider: Object {
    dynamic var name = ""
    dynamic var location = ""
    dynamic var phonenumber = ""
    dynamic var specialty = ""
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    convenience init(something: String ) {
        self.init()
        self.name = something
    }
}

func createProviders() {
    let realm = try! Realm()
    
    
    let morgan = Provider()
    morgan.name = "Dr Dick Morgan"
    morgan.location = "4735 Ogletown Stanton Rd #2112, Newark, DE 19713"
    morgan.phonenumber = "+1 302 555 1234"
    morgan.specialty = "Internist"
    let papastavros = Provider()
    papastavros.name = "Dr Luigi Papastavros "
    papastavros.location = "1701 Augustine Cut-Off, Bldg. 4, Wilmington, DE 19803"
    papastavros.phonenumber = "+1 302 555 1234"
    papastavros.specialty = "Imaging"
    let penman = Provider()
    penman.name = "Dr Emily Penman"
    penman.location = "4735 Ogletown Stanton Rd #2112, Newark, DE 19713"
    penman.phonenumber = "+1 302 555 1234"
    penman.specialty = "Breast Oncologist"
    
    
    try! realm.write {
        realm.delete((realm.objects(Profile.self)))
        realm.add(morgan)
        realm.add(papastavros)
        realm.add(penman)
    }
}

class Folder: Object {
    dynamic var name = ""
    dynamic var date = NSDate()
    let docs = List<DocumentPDF>()
    
}

class DocumentPDF: Object {
    dynamic var name = ""
    dynamic var date = NSDate()
    dynamic var rawdata = NSData()
    dynamic var thumbnailData: Data? = nil
    
    var thumbnail: UIImage? {
        get {
            if thumbnailData == nil {
                return UIImageView.fontAwesomeAsImage("fa-file-pdf-o", size: 28.0, color: AppPrimary )
            }
            return UIImage(data: thumbnailData!)
        }
        set(newImage) {
            thumbnailData = UIImagePNGRepresentation(newImage!)
        }
    }
    
}



