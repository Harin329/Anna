//
//  CountdownViewController.swift
//  Anna
//
//  Created by Harin Wu on 2020-03-17.
//  Copyright © 2020 Hao Wu. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

let db = Firestore.firestore()
var today = DayGift()

class CountdownViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var OpenImage: UIImageView!
    @IBOutlet weak var Greeting: UILabel!
    @IBOutlet weak var AR: UIButton!
    @IBOutlet weak var DaysTo: UILabel!
    
    private var myLoc = CLLocation(latitude: 49.2827, longitude: 123.1207)
    private var locationManager = CLLocationManager()
    var password = "Harin"
    var yay = Timestamp()
    var goodLoc = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        db.collection("Password").document("Password").getDocument { (document, error) in
            if let document = document, document.exists {
                self.password = document.get("?") as! String
                if (document.get("AR") as! Bool) {
                    self.AR.isHidden = false
                } else {
                    self.AR.isHidden = true
                }
                self.yay = document.get("DaysUntil") as! Timestamp
                
                self.goodLoc = document.get("NiceLocation") as! [String]
                
                let dateNow = Date(timeIntervalSince1970: TimeInterval(Timestamp().seconds))
                let dateTil = Date(timeIntervalSince1970: TimeInterval(self.yay.seconds))
                
                let daysLeft = dateTil.days(from: dateNow)
                
                self.DaysTo.text = String(daysLeft) + " Days Until Harin"
                
                //Quick Doc Adding
                /*for i in 0..<(daysLeft + 1) {
                    let d = Date().addingTimeInterval(TimeInterval(i * 86400))
                    
                    let formatter = DateFormatter()
                    formatter.timeStyle = .none
                    formatter.dateStyle = .medium
                    
                    // get the date time String from the date object
                    let date = formatter.string(from: d) // Oct 8, 2016
                    
                    print(date)
                    print(Timestamp(date: d))
                    
                    db.collection("Memories").addDocument(data: [
                        "Date": date,
                        "Link": "",
                        "Message": "Hi Babe!",
                        "Opened": false,
                        "Timestamp": Timestamp(date: d)
                    ])
                }*/
                
                if (daysLeft > 153) {
                    let alertController = UIAlertController(title: "Not Yet", message: "Check Back in " + String(daysLeft - 153) + " Days", preferredStyle: .alert)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
                
                // get the current date and time
                let currentDateTime = Date()
                
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateStyle = .medium
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                // get the date time String from the date object
                // print(currentDateTime)
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
                    self.Greeting.text = "Good Morning Anna"
                } else if (dateTimeComponents.hour! > 12 && dateTimeComponents.hour! <= 18) {
                    self.Greeting.text = "Good Afternoon Anna"
                } else if (dateTimeComponents.hour! > 18 && dateTimeComponents.hour! <= 24) {
                    self.Greeting.text = "Good Evening Anna"
                } else {
                    self.Greeting.text = "What are you doing up at this hour, Anna?"
                }
                
                print(date)
                if (daysLeft < 0) {
                    db.collection("Memories").getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            let document = querySnapshot!.documents.shuffled()[0]
                            today = DayGift(ID: document.documentID, data: document.data())
                            if (document.get("Opened") as! Bool) {
                                self.OpenImage.image = UIImage(systemName: "gift")
                            } else  {
                                self.OpenImage.image = UIImage(systemName: "gift.fill")
                            }
                        }
                    }
                } else {
                    db.collection("Memories").whereField("Date", isEqualTo: date).getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                today = DayGift(ID: document.documentID, data: document.data())
                                if (document.get("Opened") as! Bool) {
                                    self.OpenImage.image = UIImage(systemName: "gift")
                                } else  {
                                    self.OpenImage.image = UIImage(systemName: "gift.fill")
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    //Gets User Location Permission
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            print("Location status unknown.")
        }
    }
    
    //User Location Failed to Retrieve
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print ("Unable to access your current location")
    }
    
    //Function Recieves User Location and Movement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLoc = locations.last!
        let hash = Geohash.encode(latitude: myLoc.coordinate.latitude, longitude: myLoc.coordinate.longitude, length: 6)
        
        if (goodLoc.contains(hash)) {
            self.AR.isHidden = false
        } else {
            self.AR.isHidden = true
        }
        
    }
    
    @IBAction func OpenDay(_ sender: Any) {
        if (today.ID != "") {
            let alertController = UIAlertController(title: "URGENT CONFIRMATION OF LOVE", message: "Do you promise to return to Harin on or before Aug 24, 2020?", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Um...", style: .cancel, handler: nil)
            let promiseAction = UIAlertAction(title: "I Promise", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                let storyboard = UIStoryboard(name: "Countdown2020", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "DailyBoard") as! DailyViewController
                vc.DayData = today
                self.OpenImage.image = UIImage(systemName: "gift")
                self.present(vc, animated:true, completion:nil)
            })
            
            alertController.addAction(defaultAction)
            alertController.addAction(promiseAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "URGENT CONFIRMATION OF LOVE", message: "Do you promise to return to Harin on or before Aug 24, 2020?", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Um...", style: .cancel, handler: nil)
            let promiseAction = UIAlertAction(title: "I Promise", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                let storyboard = UIStoryboard(name: "Countdown2020", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "DailyBoard") as! DailyViewController
                vc.DayData = today
                self.OpenImage.image = UIImage(systemName: "gift")
                self.present(vc, animated:true, completion:nil)
            })
            
            alertController.addAction(defaultAction)
            alertController.addAction(promiseAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func Secret(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "What's The Password", message: "???", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Password"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if (textField?.text == self.password) {
                let storyboard = UIStoryboard(name: "Countdown2020", bundle: Bundle.main)
                let vc = storyboard.instantiateViewController(withIdentifier: "SecretViewController") as! SecretViewController
                self.present(vc, animated:true, completion:nil)
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
}
