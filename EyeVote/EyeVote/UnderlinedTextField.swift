//
//  Underline.swift
//  EyeVote
//
//  Created by Margaret Ikeda on 2/8/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    fileprivate var underlineLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    func setUpUnderlineLayer() {
        guard underlineLayer == nil else { return }

        let leftPoint = CGPoint.zero
        let rightPoint = CGPoint(x: frame.width, y: 0)
        let path = UIBezierPath()
        path.move(to: leftPoint)
        path.addLine(to: rightPoint)
        
        underlineLayer = CAShapeLayer()
        underlineLayer?.frame = CGRect(origin: CGPoint(x: 0, y: frame.height - 11), size: CGSize(width: frame.width, height: 2))
        underlineLayer?.path = path.cgPath
        underlineLayer?.isGeometryFlipped = true
        underlineLayer?.lineWidth = 1
        underlineLayer?.strokeColor = EyeVoteColor.textIconColor.cgColor
        underlineLayer?.strokeEnd = 1
        underlineLayer?.fillColor = nil
        
        if let _ = underlineLayer {
            layer.addSublayer(underlineLayer!)
        }
    }
}
