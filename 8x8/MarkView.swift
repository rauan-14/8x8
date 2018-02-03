//
//  markView.swift
//  8x8
//
//  Created by Rauan Zhakypbek on 2/2/18.
//  Copyright © 2018 Rauan Zhakypbek. All rights reserved.
//

import UIKit

class MarkView: UIView {
    private var shapeLayer: CAShapeLayer?
    
    var mark: Mark = .unmarked {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func getPath()-> UIBezierPath? {
        let path = UIBezierPath()
        path.lineWidth = 3.0
        switch mark {
        case .x:
            path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            path.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            path.close()
            return path
        case .o:
            path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: frame.width/2.5, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            return path
        case .unmarked:
            return nil
        }

    }

    override func draw(_ rect: CGRect) {
        if let path = getPath() {
            UIColor.white.setStroke()
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.lineWidth = 3.0
            shapeLayer.path = path.cgPath
            if self.shapeLayer == nil {
                self.layer.addSublayer(shapeLayer)
            }
            else {
                self.layer.replaceSublayer(self.shapeLayer!, with: shapeLayer)
            }
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = 1.0
            shapeLayer.add(animation, forKey: "markAnimation")
            self.shapeLayer = shapeLayer
        }
    }
}
