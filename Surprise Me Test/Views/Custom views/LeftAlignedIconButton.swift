//
//  LeftAlignedIconButton.swift
//  Surprise Me Test
//
//  Created by Eugene Ilyin on 08.06.2020.
//  Copyright © 2020 Eugene Ilyin. All rights reserved.
//
//  Original source reference:
//  https://stackoverflow.com/a/41575018/10118422

import UIKit

/// An UIButton, that has title in the center and squared image in the left edge.
/// NOTE: Button's content alignment should be set to .left / .leading.
class LeftAlignedIconButton: UIButton {
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageRect = super.imageRect(forContentRect: contentRect)
        let newImageRect = CGRect(x: imageRect.origin.x, y: imageRect.origin.y, width: imageRect.height, height: imageRect.height)
        return newImageRect
    }
    
}
