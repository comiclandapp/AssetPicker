//
//  UIButton+extensions.swift
//  TestAssetPicker
//
//  Created by Antonio Montes on 9/26/24.
//  Copyright © 2024 Antonio Montes. All rights reserved.
//

import UIKit

extension UIButton {

    @objc func adjustTo(_ size: CGSize) {
        let previousFrame = self.frame
        var newFrame = self.frame
        newFrame.size = size
        let adjustX = (size.width - previousFrame.size.width) / 2
        let adjustY = (size.height - previousFrame.size.height) / 2
        newFrame.origin.x = previousFrame.origin.x - adjustX
        newFrame.origin.y = previousFrame.origin.y - adjustY
        self.frame = newFrame
        let edgeInsets = UIEdgeInsets(top: adjustY, left: adjustX, bottom: adjustY, right: adjustX)
        self.contentEdgeInsets = edgeInsets
    }
    
    @objc func with(_ image: UIImage) {
        self.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        self.contentMode = .center
        self.showsTouchWhenHighlighted = true
        self.tintColor = UIColor.white
        self.setImage(image, for: .normal)
        let newSize = CGSize(width: 30, height: 44)
        self.adjustTo(newSize)
    }
}
