//
//  CustomHomeCell.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class CustomHomeCell: UICollectionViewCell {
    
    let iconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let titleLabel: UILabel = {
        let labl = UILabel()
        labl.textColor = UIColor(named: "blackColor")!
        labl.font = .systemFont(ofSize: 12, weight: .regular)
        labl.translatesAutoresizingMaskIntoConstraints = false
        return labl
    }()
    
    let backIconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.tintColor = UIColor(named: "blackColor")!
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(backIconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            
            backIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
        ])
    }
    
    func configure(with data: Any) {
        if let scanData = data as? ScanAndCreateData {
            iconImageView.image = scanData.img
            iconImageView.backgroundColor = UIColor(named: "blueColor")!
            iconImageView.tintColor = UIColor(named: "whiteColor")!
            titleLabel.text = scanData.label
            backIconImageView.image = scanData.backIcon
        } else if let compressData = data as? CompressData {
            iconImageView.image = compressData.img
            iconImageView.backgroundColor = UIColor(named: "redColor")!
            iconImageView.tintColor = UIColor(named: "whiteColor")!
            titleLabel.text = compressData.label
            backIconImageView.image = compressData.backIcon
        } else if let organizedData = data as? OrganizeData {
            iconImageView.image = organizedData.img
            iconImageView.tintColor = UIColor(named: "whiteColor")!
            iconImageView.backgroundColor = UIColor(named: "purpleColor")!
            titleLabel.text = organizedData.label
            backIconImageView.image = organizedData.backIcon
        } else if let convertFromData = data as? ConvertToPDFData {
            iconImageView.image = convertFromData.img
            iconImageView.tintColor = UIColor(named: "whiteColor")!
            iconImageView.backgroundColor = UIColor(named: "lightBlue")!
            titleLabel.text = convertFromData.label
            backIconImageView.image = convertFromData.backIcon
        } else if let convertToData = data as? ConvertToPDFData {
            iconImageView.image = convertToData.img
            iconImageView.tintColor = UIColor(named: "whiteColor")!
            iconImageView.backgroundColor = UIColor(named: "lightBlue")!
            titleLabel.text = convertToData.label
            backIconImageView.image = convertToData.backIcon
        } else if let editSignData = data as? EditAndSignData {
            iconImageView.image = editSignData.img
            iconImageView.tintColor = UIColor(named: "whiteColor")!
            iconImageView.backgroundColor = UIColor(named: "lightBlue")!
            titleLabel.text = editSignData.label
            backIconImageView.image = editSignData.backIcon
        }
    }
}
