//
//  TabBarViewController.swift
//  smallpdf
//
//  Created by 
//

import UIKit

// MARK: -
class TabBarViewController: UITabBarController, UITabBarControllerDelegate, UIPickerViewDelegate  {
    
    // MARK: - UI -
    let floatingBtn = UIButton()
    var transparentView: TransparentView?
    
    // MARK: - Wrap ViewControllers in Navigation Controllers -
    let toolsVC = UINavigationController(rootViewController: ToolsViewController())
    let filesVC = UINavigationController(rootViewController: FilesViewController())
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        delegate = self
        setupViewControllers()
        selectedIndex = 0
        swipeTabBars()
        addFloatingBtn()
    }
    
    func setupViewControllers() {
        // MARK: - Set titles for tab bar items -
        toolsVC.tabBarItem.title = "Tools"
        filesVC.tabBarItem.title = "Files"
        
        // MARK: - Set images for tab bar items -
        let tabBarImages = [
            UIImage(systemName: "signpost.right.fill"),
            UIImage(systemName: "book.pages.fill"),
        ]
        
        // MARK: - Assign ViewControllers and tab bar items -
        let viewControllers = [toolsVC, filesVC]
        for (index, viewController) in viewControllers.enumerated() {
            viewController.tabBarItem.image = tabBarImages[index]
        }
        
        // MARK: - Set ViewControllers for the tab bar controller -
        setViewControllers(viewControllers, animated: true)
        
        // MARK: - Customize tab bar appearance -
        self.tabBar.tintColor = UIColor(named: "blueColor")!
        self.tabBar.barTintColor = UIColor(named: "blackColor")!
        UITabBar.appearance().backgroundColor = UIColor(named: "whiteColor")!
        
        // MARK: - Add a straight line at the top of the tab bar -
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        topBorder.backgroundColor = UIColor(named: "grayColor")!.cgColor
        tabBar.layer.addSublayer(topBorder)
    }
    
    func swipeTabBars() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        guard let viewControllers = self.viewControllers else { return }
        let tabs = viewControllers.count
        if gesture.direction == .left {
            if self.selectedIndex < tabs - 1{
                self.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.selectedIndex) > 0 {
                self.selectedIndex -= 1
            }
        }
    }
    
    // MARK: -
    func addFloatingBtn() {
        self.view.addSubview(floatingBtn)
        floatingBtn.translatesAutoresizingMaskIntoConstraints = false
        floatingBtn.setupButton(background: .blue, cornerRadius: 25, img: UIImage(systemName: "plus"))
        floatingBtn.addTarget(self, action: #selector(buttonTappedFloatingBtn), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            floatingBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            floatingBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
        ])
    }
    
    @objc func buttonTappedFloatingBtn() {
        transparentView = TransparentView(frame: view.bounds, tabBarController: self)
        transparentView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if let filesNavController = self.viewControllers?[1] as? UINavigationController,
           let filesViewController = filesNavController.topViewController as? FilesViewController {
            transparentView?.delegate = filesViewController
            print("Delegate set to FilesViewController")
        } else {
            print("Failed to set delegate")
        }
        
        if let transparentView = transparentView {
            self.view.addSubview(transparentView)
        }
    }
}
