//
//  TextField.swift
//  smallpdf
//
//  Created by 
//

import UIKit

// MARK: - ReusableObject -
class TextField: UITextField {
    
    // MARK: - Object property and value initialization -
    init(placeholder: String, isSecureTextEntry: Bool, radius: CGFloat, background: UIColor, borderWidth: Int, borderColor: UIColor) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont(name: "", size: 18)
        textColor = UIColor(named: "blackColor")!
        backgroundColor = background
        layer.cornerRadius = radius
        autocapitalizationType = .none
        autocorrectionType = .no
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecureTextEntry
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.borderColor = borderColor.cgColor
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "grayColor")!])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
