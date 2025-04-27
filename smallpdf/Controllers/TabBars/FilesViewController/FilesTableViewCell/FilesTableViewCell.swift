//
//  FilesTableViewCell.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class FilesTableViewCell: UITableViewCell {
    
    let identifier = "FilesTableViewCell"
    
    // MARK: - UI -
    let menuIconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        img.tintColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(named: "whiteColor") ?? .white
            case .light:
                return UIColor(named: "blackColor") ?? .black
            default: return .yellow
            }
        }
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    var onMenuTap: (() -> Void)?
    
    // MARK: - UI -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        addGesture()
    }
    
    // MARK: - UI -
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
        addGesture()
    }
    
    func setupUI() {
        contentView.addSubview(menuIconImageView)
        NSLayoutConstraint.activate([
            menuIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            menuIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
        ])
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        menuIconImageView.addGestureRecognizer(tap)
    }
    
    @objc func menuTapped() {
        onMenuTap?()
    }
}
