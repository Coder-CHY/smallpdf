//
//  HomeViewController.swift
//  smallpdf
//
//  Created by
//

import UIKit
import VisionKit
import UniformTypeIdentifiers

class ToolsViewController: BaseViewController, CustomHomeCollectionViewDelegate {
    
    // MARK: - UI -
    let imagePicker = UIImagePickerController()
    let collection = CustomHomeCollectionView(frame: .zero)
    var selectedFileURL: URL?
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabl.text = "Tools"
        collection.customDelegate = self
        setSubviewsAndLayout()
        
    }
    
    // MARK: - Subviews and Layout -
    func setSubviewsAndLayout() {
        view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: sideMenuButton.bottomAnchor, constant: 10),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                self.openDocumentScanner()
            } else if indexPath.item == 1 {
                self.openGallery()
            }
        } else if indexPath.section == 1 {
            let action = compressData[indexPath.item].label
            if action == "Compress PDF" || action == "Strong Compress" {
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                documentPicker.shouldShowFileExtensions =
                documentPicker.restorationIdentifier == action
                present(documentPicker, animated: true)
            }
        } else if indexPath.section == 2 {
            if indexPath.item == 0 {
                let action = organizeData[indexPath.item].label
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                documentPicker.shouldShowFileExtensions =
                documentPicker.restorationIdentifier == action
                present(documentPicker, animated: true)
            } else if indexPath.item == 1 {
                
            } else if indexPath.item == 2 {
                let action = organizeData[indexPath.item].label
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                documentPicker.shouldShowFileExtensions =
                documentPicker.restorationIdentifier == action
                present(documentPicker, animated: true)
            } else if indexPath.item == 3 {
                
            }
        } else if indexPath.section == 3 {
            if indexPath.item == 0 {
                let action = convertFromPDFData[indexPath.item].label
                let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
                documentPicker.delegate = self
                documentPicker.allowsMultipleSelection = false
                documentPicker.shouldShowFileExtensions =
                documentPicker.restorationIdentifier == action
                present(documentPicker, animated: true)
            }
        } else if indexPath.section == 4 {
            let action = convertToPDFData[indexPath.item].label
            let types: [UTType] = [.pdf, .png, .rtf, .plainText, .image]
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: types)
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions =
            documentPicker.restorationIdentifier == action
            present(documentPicker, animated: true)
        } else if indexPath.section == 5 {
            let action = editAndSignData[indexPath.item].label
            let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            documentPicker.shouldShowFileExtensions =
            documentPicker.restorationIdentifier == action
            present(documentPicker, animated: true)
        }
    }
    
    func openDocumentScanner() {
        let documentCameraVC = VNDocumentCameraViewController()
        documentCameraVC.delegate = self
        present(documentCameraVC, animated: true)
    }
    
    @objc func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        } else {
            print("Photo Library is not available")
        }
    }
}

extension ToolsViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        
        let scannedImages = (0..<scan.pageCount).compactMap({ scan.imageOfPage(at: $0)})
        
        let fileName = "Scan- \(UUID().uuidString).pdf"
        
        if let pdfURL = PDFConverter.convertImagesToPDF(images: scannedImages, fileName: fileName) {
            
            if let tabBarController = self.tabBarController,
               let filesNavController = tabBarController.viewControllers?[1] as? UINavigationController,
               let filesViewController = filesNavController.topViewController as? FilesViewController {
                filesViewController.didSelectFile(url: pdfURL)
                tabBarController.selectedIndex = 1
            }
        } else {
            print("Failed to convert scanned images to PDF")
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
    }
}

extension ToolsViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let fileName = "Gallery\(UUID().uuidString)"
            if let pdfURL = PDFConverter.convertImageToPDF(image: image, fileName: fileName) {
                
                if let tabBarController = self.tabBarController,
                   let filesNavController = tabBarController.viewControllers?[1] as? UINavigationController,
                   let filesViewController = filesNavController.topViewController as? FilesViewController {
                    filesViewController.didSelectFile(url: pdfURL)
                    tabBarController.selectedIndex = 1
                }
            } else {
                print("Failed to convert scanned images to PDF")
            }
        }
        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ToolsViewController {
    func convertImageToPDF(image: UIImage, fileName: String) -> URL? {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        do {
            let docDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let pdfURL = docDirectory.appendingPathComponent(fileName).appendingPathExtension("pdf")
            
            let data = pdfRenderer.pdfData { context in
                context.beginPage()
                image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            }
            
            try data.write(to: pdfURL)
            print("PDF saved to: \(pdfURL.path)")
            return pdfURL
        } catch {
            print("Error converting image to PDF: \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension ToolsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedURLs = urls.first else { return }
        selectedFileURL = selectedURLs
        
        let compressionQuality: CGFloat = controller.restorationIdentifier == "Strong Compress" ? 0.3 : 0.5
        let baseName = selectedURLs.deletingPathExtension().lastPathComponent
        let prefix = controller.restorationIdentifier == "Strong Compress" ? "strong_compresses_" : "compressed_"
        let fileName = "\(prefix)\(baseName)"
        
        do {
            let docDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationURL = docDirectory.appendingPathComponent(selectedURLs.lastPathComponent)
            
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.copyItem(at: selectedURLs, to: destinationURL)
            }
            
            //let compressedURL = try PDFCompressor
        } catch {
            
        }
    }
}
