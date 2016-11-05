//
//  ConfirmTakeVC.swift
//  Prin
//
//  Created by Kristofer Younger on 11/5/16.
//  Copyright © 2016 Tioga Digital. All rights reserved.
//

import UIKit
import RealmSwift

class ConfirmTakeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var summaryTest: UITextView!
    @IBOutlet weak var attachs: UITableView!

    var objects: Results<DocumentPDF>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createPDFs()
        self.attachs.dataSource = self
        self.attachs.delegate = self
        
        // Do any additional setup after loading the view.
        self.summaryTest.text = "This visit with Dr Morgan on Nov 5th, 2016, has a few attachments with things you may need to attend to."
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
        cell.textLabel!.text = object?.name
        cell.imageView!.image = object?.thumbnail
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func createPDFs() {
        let realm = try! Realm()
        
        let doc1 = DocumentPDF()
        doc1.name = "Lab Results Blood Sugar"
        let doc2 = DocumentPDF()
        doc2.name = "T1 Results"
        let doc3 = DocumentPDF()
        doc3.name = "Normal Hemolytics"
        
        try! realm.write {
            realm.add(doc1)
            realm.add(doc2)
            realm.add(doc3)
        }
        
        self.objects = realm.objects(DocumentPDF.self)
        
    }

}
