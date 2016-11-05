//
//  ConfirmShareVC.swift
//  Prin
//
//  Created by Kristofer Younger on 11/5/16.
//  Copyright © 2016 Tioga Digital. All rights reserved.
//

import UIKit

class ConfirmShareVC: UIViewController {

    let enableShareSegue = "enableShareSegue"
    var object: String!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textRequest: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func doShare(_ sender: Any) {
        self.performSegue(withIdentifier: enableShareSegue, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textRequest.text = defaultText
        self.nameLabel.text = "Alison Walker"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == self.enableShareSegue {
        //    let destination =  segue.destination as? EnableShareVC
        //}
    }

    let secthead = "Information Requested:"
    let messages = ["Normal Name, Insurance, Demographics","Allergies","All Current Medications a dietary supplements."]

    
    let defaultText = "Dr. Morgan is requesting normal and customary information about you and your current health."

    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let str = messages[indexPath.row]
        cell.textLabel!.text = str
        
        return cell
    }

}
