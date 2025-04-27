//
//  BaseViewController.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - UI -
    let sideMenuButton = Button(image: UIImage(systemName: "line.3.horizontal"), text: "", btnTitleColor: .clear, backgroundColor: .clear, radius: 0, imageColor: UIColor(named: "blackColor")!)
    let titleLabl = Label(label: "", textColor: UIColor(named: "blackColor")!, font: UIFont.systemFont(ofSize: 18, weight: .black))
    
    var sideMenuViewController = SideMenuViewController()
    
    var sideMenuShowing = false
    var sideMenuWidth: CGFloat = 0
    var overlayView = UIView()
    
    // MARK: - UI -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "whiteColor")!
        setupUI()
    }
    
    // MARK: - Subviews and Layout -
    func setupUI() {
        view.addSubview(sideMenuButton)
        view.addSubview(titleLabl)
        NSLayoutConstraint.activate([
            sideMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            sideMenuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            
            titleLabl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabl.leadingAnchor.constraint(equalTo: sideMenuButton.trailingAnchor, constant: 20),
        ])
        sideMenuButton.addTarget(self, action: #selector(toggleSideBar), for: .touchUpInside)
    }
    
    @objc func toggleSideBar() {
        if sideMenuShowing {
            hideSideBar()
        } else {
            showSideBar()
        }
    }
    
    func showSideBar() {
        sideMenuWidth = view.frame.width * 0.8
        addChild(sideMenuViewController)
        view.addSubview((sideMenuViewController.view))
        
        self.sideMenuViewController.view.frame = CGRect(x: 0, y: 0, width: self.sideMenuWidth, height: self.view.frame.height)
        self.sideMenuShowing = true
        self.tabBarController?.tabBar.isHidden = true
        
        if let tabBarVC = self.tabBarController as? TabBarViewController {
            tabBarVC.floatingBtn.isHidden = true
        }
        
        overlayView = UIView(frame: CGRect(x: sideMenuWidth, y: 0, width: view.frame.width - sideMenuWidth, height: view.frame.height))
        overlayView.backgroundColor = UIColor(named: "blackColor")!.withAlphaComponent(0.5)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlayView.addGestureRecognizer(tapGesture)
        
        view.addSubview(overlayView)
    }
    
    func hideSideBar() {
        sideMenuWidth = view.frame.width * 0.5
        self.sideMenuViewController.view.frame = CGRect(x: -self.sideMenuWidth, y: 0, width: self.sideMenuWidth, height: self.view.frame.height)
        self.sideMenuViewController.view.removeFromSuperview()
        self.sideMenuViewController.removeFromParent()
        self.sideMenuShowing = false
        
        self.tabBarController?.tabBar.isHidden = false
        
        if let tabBarVC = self.tabBarController as? TabBarViewController {
            tabBarVC.floatingBtn.isHidden = false
        }
        overlayView.removeFromSuperview()
    }
    
    @objc func overlayTapped() {
        hideSideBar()
    }
}
