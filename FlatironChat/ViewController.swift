//
//  ViewController.swift
//  FlatironChat
//
//  Created by Johann Kerr on 3/23/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var screenNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func joinBtnPressed(_ sender: Any) {
        if let screenName = screenNameField.text {
            
            UserDefaults.standard.set(screenName, forKey: "screenName")
            
            FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
                self.performSegue(withIdentifier: "openChannel", sender: self)
            })
            
            
        
            
        }
    }

}

