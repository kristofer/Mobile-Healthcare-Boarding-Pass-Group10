//
//  ShareVC.swift
//  
//
//  Created by Kristofer Younger on 11/5/16.
//
//

import UIKit
import SwiftQRCode

class ShareVC: UIViewController {

    let confirmShareSegue = "confirmShareSegue"
    //let scanner = QRCode()

    @IBOutlet weak var scannerView: UIView!
    
    @IBAction func neverMind(_ sender: Any) {
        self.performSegue(withIdentifier: self.confirmShareSegue, sender: "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //scanner.prepareScan(scannerView) { (stringValue) -> () in
        //    NSLog(stringValue)
         //   self.performSegue(withIdentifier: self.confirmShareSegue, sender: stringValue)
        //}
        //scanner.scanFrame = view.bounds
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // start scan
        //scanner.startScan()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.confirmShareSegue {
            let destination =  segue.destination as? ConfirmShareVC
            destination?.object = sender as! String
        }
    }


}
