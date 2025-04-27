//
//  ModalTableViewCell.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class ModalTableViewCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let titleLabel: UILabel = {
        let labl = UILabel()
        labl.textColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(named: "whiteColor") ?? .white
            case .light:
                return UIColor(named: "blackColor") ?? .black
            default: return .yellow
            }
        }
        labl.font = .systemFont(ofSize: 12, weight: .regular)
        labl.translatesAutoresizingMaskIntoConstraints = false
        return labl
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
        ])
    }
    
    func configure(with data: ModalTableViewData) {
        titleLabel.text = data.label
        iconImageView.image = data.img
    }
}
