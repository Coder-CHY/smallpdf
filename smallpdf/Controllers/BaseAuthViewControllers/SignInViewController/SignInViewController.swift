//
//  SignInViewController.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class SignInViewController: BaseAuthViewController {
    
    // MARK: - UI -
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabl.text = "Sign in"
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
