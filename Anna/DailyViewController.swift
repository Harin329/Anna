//
//  DailyViewController.swift
//  Anna
//
//  Created by Harin Wu on 2020-03-18.
//  Copyright © 2020 Hao Wu. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class DailyViewController: UIViewController {
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var DailyPic: UIImageView!
    @IBOutlet weak var DailyMessage: UITextView!
    
    var DayData = DayGift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        db.collection("Memories").document(DayData.ID).updateData([
            "Opened": true
        ])
        
        Date.text = DayData.Date
        DailyMessage.text = DayData.Message
        if (DayData.Image != "") {
            DailyPic.sd_setImage(with: URL(string: DayData.Image))
        }
        
    }
    
    @IBAction func OpenURL(_ sender: Any) {
        if (DayData.Link != "") {
            if let url = URL(string: DayData.Link) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    if UIApplication.shared.canOpenURL(url as URL) {
                        UIApplication.shared.openURL(url as URL)
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "No Link From Harin Today :(", message: "Check Back Tomorrow!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    

}
