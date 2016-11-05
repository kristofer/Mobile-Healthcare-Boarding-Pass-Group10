//
//  ProfilesVC.swift
//  Prin
//
//  Created by Kristofer Younger on 11/5/16.
//  Copyright © 2016 Tioga Digital. All rights reserved.
//

import UIKit
import RealmSwift

class ProfilesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let profileDetailSegue = "profileDetailSegue"
    let addProfileSegue = "addProfileSegue"
    let editProfileSegue = "editProfileSegue"
    
    @IBOutlet weak var currentProfile: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var objects: Results<Profile>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadProfiles()
        let realm = try! Realm()
        self.objects = realm.objects(Profile.self)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if (self.objects?.count)! > 0 {
            self.currentProfile.text = self.objects?[0].name()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects?[indexPath.row]
        cell.textLabel!.text = object?.name()
        cell.detailTextLabel!.text = object?.relation
        //cell.imageView!.image = object?.thumbnail
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = self.objects?[indexPath.row]
        self.performSegue(withIdentifier: profileDetailSegue, sender: selected)
        
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
    
    func loadProfiles() {
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.profileDetailSegue {
            let destination =  segue.destination as? ProfileDetailVC
                destination?.object = sender as! Profile
        }
    }

}
