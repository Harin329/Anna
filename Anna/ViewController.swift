//
//  ViewController.swift
//  Anna
//
//  Created by Harin Wu on 2020-03-17.
//  Copyright © 2020 Hao Wu. All rights reserved.
//

import UIKit
import Firebase

let db = Firestore.firestore()
var today = DayGift()

class ViewController: UIViewController {
    @IBOutlet weak var OpenImage: UIImageView!
    @IBOutlet weak var Greeting: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        // get the date time String from the date object
        let date = formatter.string(from: currentDateTime) // Oct 8, 2016
        // get the user's calendar
        let userCalendar = Calendar.current
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .hour
        ]
        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        // now the components are available
        if (dateTimeComponents.hour! >= 7 && dateTimeComponents.hour! <= 12) {
            Greeting.text = "Good Morning Anna"
        } else if (dateTimeComponents.hour! > 12 && dateTimeComponents.hour! <= 18) {
            Greeting.text = "Good Afternoon Anna"
        } else if (dateTimeComponents.hour! > 18 && dateTimeComponents.hour! <= 24) {
            Greeting.text = "Good Evening Anna"
        } else {
            Greeting.text = "What are you doing up at this hour, Anna?"
        }
        
        db.collection("Memories").whereField("Date", isEqualTo: date).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    today = DayGift(ID: document.documentID, data: document.data())
                    if (document.get("Opened") as! Bool) {
                        self.OpenImage.image = UIImage(named: "gift")
                    } else  {
                        self.OpenImage.image = UIImage(named: "gift.fill")
                    }
                }
            }
        }
    }
    
    @IBAction func OpenDay(_ sender: Any) {
        if (today.ID != "") {
            let alertController = UIAlertController(title: "URGENT CONFIRMATION OF LOVE", message: "Do you promise to return to Harin on or before Aug 24, 2020?", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Um...", style: .cancel, handler: nil)
            let promiseAction = UIAlertAction(title: "I Promise", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "DailyBoard") as! DailyViewController
                vc.DayData = today
                self.present(vc, animated:true, completion:nil)
            })
            
            alertController.addAction(defaultAction)
            alertController.addAction(promiseAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

