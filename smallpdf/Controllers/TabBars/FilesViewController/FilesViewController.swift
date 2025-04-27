//
//  FilesViewController.swift
//  smallpdf
//
//  Created by 
//

import UIKit
import QuickLook
import PDFKit

class FilesViewController: BaseViewController, TransparentViewDelegateForFiles, QLPreviewControllerDataSource {
    
    // MARK: - UI -
    var savedFiles: [URL] = []
    var filesTableView: UITableView!
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(named: "whiteColor")!
        titleLabl.text = "Files"
        setupFilesTableView()
        loadSavedFiles()
    }
    
    // MARK: - Lifecycle -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedFiles()
        filesTableView.reloadData()
        print("FilesViewController will appear, savedFiles: \(savedFiles)")
    }
    
    func didSelectFile(url: URL) {
        print("Delegate called with URL: \(url)")
        savedFiles.append(url)
        DispatchQueue.main.async {
            self.filesTableView.reloadData()
        }
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    func loadSavedFiles() {
        let fileManager = FileManager.default
        
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileUrls = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            
            savedFiles = fileUrls
            filesTableView.reloadData()
            print("saved files: \(savedFiles)")
        } catch {
            print("error loading saved files: \(error.localizedDescription)")
        }
    }
    
    func setupFilesTableView() {
        if filesTableView == nil {
            filesTableView = UITableView()
            filesTableView.translatesAutoresizingMaskIntoConstraints = false
        }
        filesTableView.delegate = self
        filesTableView.dataSource = self
        filesTableView.backgroundColor = UIColor(named: "whiteColor")!
        filesTableView.register(FilesTableViewCell.self, forCellReuseIdentifier: "FilesTableViewCell")
        setSubviewsAndLayout()
    }
    
    func setSubviewsAndLayout() {
        view.addSubview(filesTableView)
        NSLayoutConstraint.activate([
            filesTableView.topAnchor.constraint(equalTo: sideMenuButton.bottomAnchor, constant: 10),
            filesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            filesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            filesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
}

// MARK: - Extensions -
extension FilesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of saved files: \(savedFiles.count)")
        return savedFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilesTableViewCell", for: indexPath) as? FilesTableViewCell else {
            return UITableViewCell()
        }
        let fileUrl = savedFiles[indexPath.row]
        cell.textLabel?.text = fileUrl.lastPathComponent
        cell.textLabel?.font = .systemFont(ofSize: 10, weight: .regular)
        cell.menuIconImageView.image = UIImage(systemName: "ellipsis")
        cell.onMenuTap = { [weak self] in
            self?.presentModalBottomSheet(for: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let fileURL = savedFiles[indexPath.row]
        
        let previewVC = QLPreviewController()
        previewVC.dataSource = self
        previewVC.currentPreviewItemIndex = indexPath.row
        present(previewVC, animated: true)
    }
    
    func presentModalBottomSheet(for indexPath: IndexPath) {
        let fileURL = savedFiles[indexPath.row]
        let vc = ModalVC(fileName: fileURL.lastPathComponent, fileURL: fileURL)
        vc.delegate = self
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        present(vc, animated: true)
    }
}

extension FilesViewController: ModalVCDelegate  {
    func didCompressFile(to newURL: URL) {
        savedFiles.append(newURL)
        filesTableView.reloadData()
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return savedFiles.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        return savedFiles[index] as QLPreviewItem
    }
    
    func didRenameFile(from oldURL: URL, to newURL: URL) {
        if let index = savedFiles.firstIndex(of: oldURL) {
            savedFiles[index] = newURL
            filesTableView.reloadData()
        }
    }
    
    func didDeleteFile(at fileURL: URL) {
        if let index = savedFiles.firstIndex(of: fileURL) {
            savedFiles.remove(at: index)
            filesTableView.reloadData()
        }
    }
}
