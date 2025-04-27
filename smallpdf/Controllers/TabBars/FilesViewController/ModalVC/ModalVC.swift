//
//  ModalVC.swift
//  smallpdf
//
//  Created by
//

import UIKit
import PDFKit
import QuickLook

class ModalVC: UIViewController {
    
    let fileName: String
    let fileURL: URL
    let itemDataSource = modalTableViewData
    var delegate: ModalVCDelegate?
    var previewURL: URL?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = fileName
        label.textColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(named: "whiteColor") ?? .yellow : UIColor(named: "blackColor") ?? .white
        }
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // MARK: - UI -
    lazy var modalTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "whiteColor")!
        tableView.register(ModalTableViewCell.self, forCellReuseIdentifier: "ModalTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    init(fileName: String, fileURL: URL) {
        self.fileName = fileName
        self.fileURL = fileURL
        //self.fileExtension = fileExtension
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .systemBackground : UIColor(named: "whiteColor") ?? .white
        }
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(modalTableView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            
            modalTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            modalTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            modalTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            modalTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
}

// MARK: - Extensions -
extension ModalVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "ModalTableViewCell", for: indexPath) as? ModalTableViewCell)!
        let action = itemDataSource[indexPath.row]
        cell.configure(with: action)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            print("OCR tapped")
        case 1:
            print("Compress pdf tapped")
            compressPDF()
        case 2:
            print("Convert to pdf tapped")
            convertToPDF()
        case 3:
            print("eSigned tapped")
            eSignPDF()
        case 4:
            print("Edit tapped")
            editFile()
        case 5:
            print("Organize pages tapped")
        case 6:
            shareFile()
        case 7:
            shareFile()
        case 8:
            print("Save to cloud tapped")
            saveToCloud()
        case 9:
            promptRename()
        case 10:
            deleteFile()
        default:
            print("")
        }
    }
    
    func compressPDF() {
        guard let document = PDFDocument(url: fileURL) else { return }
        
        let fileManager = FileManager.default
        let directoryURL = fileURL.deletingLastPathComponent()
        let baseName = fileURL.deletingPathExtension().lastPathComponent
        let newFileName = "\(baseName)"
        let newFileURL = directoryURL.appendingPathComponent(newFileName)
        
        guard !fileManager.fileExists(atPath: newFileURL.path) else {
            return
        }
        
        do {
            let compressedDocument = PDFDocument()
            
            for pageIndex in 0..<document.pageCount {
                guard let page = document.page(at: pageIndex) else { continue }
                
                let pageBounds = page.bounds(for: .mediaBox)
                let imageSize = CGSize(width: pageBounds.width, height: pageBounds.height)
                let renderer = UIGraphicsImageRenderer(size: imageSize)
                let image = renderer.image { context in
                    UIColor(named: "whiteColor")?.setFill()
                    context.fill(pageBounds)
                    context.cgContext.translateBy(x: -pageBounds.minX, y: -pageBounds.minY)
                    page.draw(with: .mediaBox, to: context.cgContext)
                }
                
                guard let compressedData = image.jpegData(compressionQuality: 0.5) else { continue }
                guard let compressedImage = UIImage(data: compressedData) else { continue }
                
                let newPage = PDFPage(image: compressedImage)
                compressedDocument.insert(newPage!, at: pageIndex)
                guard compressedDocument.write(to: newFileURL) else {
                    throw NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey:""])
                }
                
                if let attributes = try? fileManager.attributesOfItem(atPath: newFileURL.path),
                   let fileSize = attributes[.size] as? Int64 {
                    
                }
                
                delegate?.didCompressFile(to: newFileURL)
                previewURL = newFileURL
                
                let previewVC = QLPreviewController()
                previewVC.dataSource = self
                present(previewVC, animated: true)
            }
        } catch {
            print("Failed to compress PDF: \(error.localizedDescription)")
        }
    }
    
    func convertToPDF() {
        guard let document = PDFDocument(url: fileURL) else { return }
    }
    
    func eSignPDF() {
        guard let document = PDFDocument(url: fileURL) else { return }
    }
    
    func editFile() {
        guard let document = PDFDocument(url: fileURL) else { return }
    }
    
    func renameFile(to newName: String) {
        let newURL = fileURL.deletingLastPathComponent().appendingPathComponent(newName)
        let extensionName = fileURL.pathExtension
        let newFileName = newName.hasSuffix("\(extensionName)") ? newName : "\(newName).\(extensionName)"
        let newFileURL = newURL.appendingPathComponent(newFileName)
        
        do {
            try FileManager.default.moveItem(at: fileURL, to: newURL)
            delegate?.didRenameFile(from: fileURL, to: newFileURL)
            dismiss(animated: true)
        } catch {
            print("Failed to rename file: \(error)")
        }
    }
    
    func saveToCloud() {
        let container = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("")
        guard let destinationURL = container?.appendingPathComponent(fileName) else { return }
        try? FileManager.default.copyItem(at: fileURL, to: destinationURL)
    }
    
    func shareFile() {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    func promptRename() {
        let alert = UIAlertController(title: "Rename File", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.text = self.fileName
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { _ in
            if let newName = alert.textFields?.first?.text, !newName.isEmpty {
                self.renameFile(to: newName)
            }
        }))
        present(alert, animated: true)
    }
    
    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: fileURL)
            delegate?.didDeleteFile(at: fileURL)
            dismiss(animated: true)
        } catch {
            print("Failed to delete file \(error)")
        }
    }
}

extension ModalVC: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewURL != nil ? 1 : 0
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        return previewURL! as QLPreviewItem
    }
}
