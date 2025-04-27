//
//  ScanAndCreateHeaders.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class ScanAndCreateHeaders: UICollectionReusableView {
    //MARK: - Objects initialization
    static let identifier = "ScanAndCreateHeaders"
    
    let titleLbl = Label(label: "Scan & Create", textColor: UIColor(named: "blackColor")!, font: UIFont.systemFont(ofSize: 15, weight: .regular))
    
    public func configure() {
        addSubview(titleLbl)
    }
    
    //MARK: - Lifecycle -
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSectionHeaders()
    }
    
    // MARK: - Subviews and Layout -
    func setupSectionHeaders() {
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
        ])
    }
}
