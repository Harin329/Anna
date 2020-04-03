//
//  SecretViewController.swift
//  Anna
//
//  Created by Harin Wu on 2020-03-18.
//  Copyright © 2020 Hao Wu. All rights reserved.
//

import UIKit

class SecretViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func Nothing(_ sender: Any) {
        let alertController = UIAlertController(title: "This is my life without you :(", message: "Yup, Nothing. My life is nothing without you, I really miss you babe <3", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Oh", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
        /*db.collection("Password").document("Password").updateData([
            "AR": true
        ])*/
    }
    
}
