//
//  SignUpViewController.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class SignUpViewController: BaseAuthViewController {
    
    // MARK: - UI -
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabl.text = "Sign up"
        btn.addTarget(self, action: #selector(authAction), for: .touchUpInside)
    }
    
    override func authAction() {
        AuthManager.shared.signIn() {
            DispatchQueue.main.async {
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
    }
}
