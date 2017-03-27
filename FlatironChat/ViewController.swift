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
        
        override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBOutlet weak var textField: UITextField!

    @IBAction func joinBtnPressed(_ sender: Any) {
        if let screenName = textField.text {
            
            FireBaseManager.addUser(name: screenName)
            UserDefaults.standard.set(screenName, forKey: "screenName")
            
            
            self.performSegue(withIdentifier: "openChannel", sender: self)
        }
        

    }
    

}

