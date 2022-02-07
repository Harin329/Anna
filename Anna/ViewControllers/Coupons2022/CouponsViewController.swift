//
//  CouponsViewController.swift
//  Anna
//
//  Created by Harin Wu on 2022-02-07.
//  Copyright © 2022 Hao Wu. All rights reserved.
//

import UIKit

class CouponsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var couponCollectionView: UICollectionView!
    
    var coupons = [Coupon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponCollectionView.delegate = self
        couponCollectionView.dataSource = self
        
        
        db.collection("Coupons").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let coupon = Coupon(ID: document.documentID, data: document.data())
                    self.coupons.append(coupon)
                    self.coupons.sort {
                        ($0.Valid) && !($1.Valid)
                    }
                }
                self.couponCollectionView.reloadData()
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = couponCollectionView.frame.width
        return CGSize(width: width, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath as IndexPath) as! CouponCollectionViewCell
        let current = self.coupons[indexPath.row]
        
        cell.couponText.text = current.Text
        cell.Category.text = current.Category
        
        if (current.Category == "Date") {
            cell.backgroundColor = UIColor.red
        } else if (current.Category == "Love") {
            cell.backgroundColor = UIColor.systemPink
        } else if (current.Category == "Todo") {
            cell.backgroundColor = UIColor.systemYellow
        }
        
        if (!current.Valid) {
            cell.backgroundColor = UIColor.darkGray
        }
        
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.coupons[indexPath.row].Valid) {
            let alertController = UIAlertController(title: "Use this coupon?", message: "Show Harin the coupon and he'll get right on it!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Wait, no...", style: .cancel, handler: nil)
            let goAction = UIAlertAction(title: "Let's go!", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                db.collection("Coupons").document(self.coupons[indexPath.row].ID).updateData([
                    "Valid": false
                ])
                
                self.coupons[indexPath.row].Valid = false
                self.couponCollectionView.reloadData()
            })
            
            alertController.addAction(defaultAction)
            alertController.addAction(goAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Coupon expired!", message: ":(", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Aww", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
