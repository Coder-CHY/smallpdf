//
//  BaseAuthViewController.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class BaseAuthViewController: UIViewController, UITextFieldDelegate {
    // MARK: - UI -
    var isFloatingLabelVisible = false
    
    let titleLabl = Label(label: "", textColor: UIColor(named: "blackColor")!, font: UIFont.systemFont(ofSize: 16, weight: .bold))
    
    let btn = Button(image: UIImage(named: "googleIcon"), text: "Continue with Google", btnTitleColor: UIColor(named: "blackColor")! , backgroundColor: .clear, radius: 30, imageColor: .clear)
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupBtn() {
        if let icon = btn.imageView?.image {
            let config = UIImage.SymbolConfiguration(pointSize: 20)
            let scaleIcon = icon.withConfiguration(config)
            btn.setImage(scaleIcon, for: .normal)
        }
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor(named: "blackColor")!.cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 20)
        btn.contentHorizontalAlignment = .left
        btn.imageView?.contentMode = .scaleAspectFit
    }
    
    // MARK: - Subviews and Layout -
    func setupUI() {
        view.addSubview(titleLabl)
        view.addSubview(btn)
        NSLayoutConstraint.activate([
            titleLabl.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            titleLabl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            btn.heightAnchor.constraint(equalToConstant: 55),
        ])
        btn.addTarget(self, action: #selector(authAction), for: .touchUpInside)
        setupBtn()
    }
    
    @objc func authAction() {}
    
    //MARK: - Method to show alert -
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    //MARK: - Method to show alert -
    func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        viewController.present(alert, animated: true)
    }
}
