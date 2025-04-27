//
//  StackView.swift
//  smallpdf
//
//  Created by 
//

import Foundation
import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, arrangedSubViews: [UIView], spacing: CGFloat, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangedSubViews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
