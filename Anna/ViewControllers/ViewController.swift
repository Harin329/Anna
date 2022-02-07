//
//  ViewController.swift
//  Anna
//
//  Created by Harin Wu on 2022-02-06.
//  Copyright © 2022 Hao Wu. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var Greeting: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGreeting()
    }
    
    @IBAction func OpenGift(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Coupons2022", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CouponsViewController") as! CouponsViewController
        self.present(vc, animated:true, completion:nil)
    }
    
    
    @IBAction func ViewPast(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Countdown2020", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountdownViewController") as! CountdownViewController
        self.present(vc, animated:true, completion:nil)
    }
    
    func setGreeting() {
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // get the date time String from the date object
        print(currentDateTime)
        _ = formatter.string(from: currentDateTime) // Oct 8, 2016
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
    }
}
