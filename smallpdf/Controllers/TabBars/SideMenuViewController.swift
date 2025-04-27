//
//  SideMenuViewController.swift
//  smallpdf
//
//  Created by 
//

import UIKit
import GoogleSignIn
import GoogleSignInSwift

class SideMenuViewController: UIViewController {
    
    // MARK: - UI -
    let profileImage = UIImageView()
    
    let topView = UIView()
    
    let emailLabel = UILabel()
    
    let topLabel = UILabel()
    
    let createAccountButton = UIButton()
    
    let bottomLabel = UILabel()
    
    let signInButton = UIButton()
    
    let signOutButton = UIButton()
    
    var signInStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")!
        setupUI()
        updateUIForAuthState()
    }
    
    // MARK: - Lifecycle -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        updateUIForAuthState()
    }
    
    func updateUIForAuthState() {
        if let user = GIDSignIn.sharedInstance.currentUser {
            emailLabel.text = "\(user.profile?.email ?? "No email")"
            topLabel.isHidden = true
            topView.isHidden = true
            createAccountButton.isHidden = true
            bottomLabel.isHidden = true
            signInButton.isHidden = true
            profileImage.tintColor = UIColor(named: "greenColor")!
            signOutButton.isHidden = false
        } else {
            topLabel.text = "Create an account to sync your files\n and use the Smallpdf Pro on our\n website."
            createAccountButton.isHidden = false
            bottomLabel.isHidden = false
            signInButton.isHidden = false
            profileImage.tintColor = UIColor(named: "greenColor")!
            topView.isHidden = false
            emailLabel.isHidden = true
            signOutButton.isHidden = true
        }
    }
    
    func setupUI() {
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.tintColor = UIColor(named: "greenColor")!
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.textColor = UIColor(named: "blackColor")!
        emailLabel.font = .systemFont(ofSize: 16, weight: .bold)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImage)
        view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 50),
            profileImage.heightAnchor.constraint(equalToConstant: 50),
            
            emailLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = UIColor(named: "blueColor")!.withAlphaComponent(0.2)
        topView.layer.cornerRadius = 8
        
        view.addSubview(topView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.4),
            topView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/4.5),
        ])
        
        topLabel.text = "Create an account to sync your files\n and use the Smallpdf Pro on our\n website."
        topLabel.textColor = UIColor(named: "grayColor")!
        topLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
        topView.addSubview(topLabel)
        
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.setTitle("Create account", for: .normal)
        createAccountButton.setTitleColor(UIColor(named: "whiteColor")!, for: .normal)
        createAccountButton.backgroundColor = UIColor(named: "blueColor")!
        createAccountButton.layer.cornerRadius = 25
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .black)
        createAccountButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        topView.addSubview(createAccountButton)
        
        bottomLabel.text = "Already have an account?"
        bottomLabel.textColor = UIColor(named: "blackColor")!
        bottomLabel.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(bottomLabel)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(UIColor(named: "blueColor")!, for: .normal)
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        signInButton.titleLabel?.font = font
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        topView.addSubview(signInButton)
        
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Log out", for: .normal)
        signOutButton.setTitleColor(UIColor(named: "blackColor")!, for: .normal)
        signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        view.addSubview(signOutButton)
        
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 20),
            topLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            
            createAccountButton.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20),
            createAccountButton.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.8),
            createAccountButton.heightAnchor.constraint(equalToConstant: 50),
            
            bottomLabel.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 20),
            bottomLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 40),
            
            signInButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 13),
            signInButton.leadingAnchor.constraint(equalTo: bottomLabel.trailingAnchor, constant: 1),
            
            signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc func createButtonTapped() {
        let vc = SignInViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "blackColor")!
    }
    
    @objc func signInButtonTapped() {
        let vc = SignInViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "blackColor")!
    }
    
    @objc func signOutButtonTapped() {
        AuthManager.shared.signOut() {
            DispatchQueue.main.async {
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
    }
}
