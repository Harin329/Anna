//
//  CouponCollectionViewCell.swift
//  Anna
//
//  Created by Harin Wu on 2022-02-07.
//  Copyright © 2022 Hao Wu. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var couponText: UILabel!
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var LineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        Category.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        drawDottedLine(start: CGPoint(x: LineView.bounds.midX, y: LineView.bounds.minY), end: CGPoint(x: LineView.bounds.midX, y: LineView.bounds.maxY), view: LineView)

    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineDashPattern = [5, 5] // 5 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
}
