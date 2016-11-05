//
//  ProfileDetailVC.swift
//  Prin
//
//  Created by Kristofer Younger on 11/5/16.
//  Copyright © 2016 Tioga Digital. All rights reserved.
//

import UIKit
import RealmSwift



class ProfileDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let folderDetailSegue = "folderDetailSegue"
    let editProvidersSegue = "editProvidersSegue"
    let personalPageSegue = "personalPageSegue"
    
    @IBOutlet weak var tableView: UITableView!
    var object: Profile!
    var providers: Results<Provider>?
    var appts: Results<Folder>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let realm = try! Realm()
        
        self.providers = realm.objects(Provider.self)
        self.appts = realm.objects(Folder.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //NSLog("\(section) Header")
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Demographics"
        case 2:
            return "Insurance Provider"
        case 3:
            return "Medications"
        case 4:
            return "Allergies"
        case 5:
            return "Doctors"
        case 6:
            return "Appointments"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSLog("\(section) NumOfrows")
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return object.medications.count
        case 4:
            return object.allergies.count
        case 5:
            return self.providers!.count
        case 6:
            return self.appts!.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        //NSLog("\(section)/\(row) Cell")
        switch section {
        case 0:
            cell.textLabel!.text = object.name()
        case 1:
            let foo = object.demos!
            cell.textLabel!.text = "\(foo.gender), Bloodtype: \(foo.bloodtype), Eye Color: \(foo.eyecolor) "
        case 2:
            let foo = object.insurance!
            cell.textLabel!.text = "\(foo.carrier), Group: \(foo.groupname) "
        case 3:
            let foo = object.medications[row]
            cell.textLabel!.text = "\(foo.name), dosage: \(foo.dosage) "
        case 4:
            let foo = object.allergies[row]
            cell.textLabel!.text = "\(foo.name)"
        case 5:
            let foo = self.providers![row]
            cell.textLabel!.text = "\(foo.name)"
        case 6:
            let foo = self.appts![row]
            cell.textLabel!.text = "\(foo.name)"
        default:
            break
        }
        
        //cell.imageView!.image = object?.thumbnail
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
