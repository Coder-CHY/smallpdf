//
//  TransparentView.swift
//  smallpdf
//
//  Created by 
//

import UIKit
import VisionKit
import Vision

class TransparentView: UIView, UIDocumentPickerDelegate {
    
    var delegate: TransparentViewDelegateForFiles?
    
    // MARK: - UI -
    var tabBarController: UITabBarController?
    var floatingBtn: UIButton!
    var cameraBtn: UIButton!
    var cameraLabel: UILabel!
    var cameraStackView: UIStackView!
    
    var galleryBtn: UIButton!
    var galleryLabel: UILabel!
    var galleryStackView: UIStackView!
    
    var filesBtn: UIButton!
    var filesLabel: UILabel!
    var filesStackView: UIStackView!
    
    var parentStackView: UIStackView!
    let imagePicker = UIImagePickerController()
    
    // MARK: - Lifecycle -
    init(frame: CGRect, tabBarController: UITabBarController?) {
        super.init(frame: frame)
        self.tabBarController = tabBarController
        self.backgroundColor = UIColor(named: "blackColor")!.withAlphaComponent(0.5)
        setupCamera()
        setupGallery()
        setupFiles()
        
        addFloatingBtn()
        
        setupParentStackView()
    }
    
    func setupCamera() {
        cameraBtn = Button(image: UIImage(systemName: "camera.fill"), text: "", btnTitleColor: .clear, backgroundColor: UIColor(named: "whiteColor")!, radius: 0, imageColor: UIColor(named: "blackColor")!)
        cameraLabel = Label(label: "Camera", textColor: UIColor(named: "whiteColor")!, font: UIFont.systemFont(ofSize: 16, weight: .bold))
        cameraStackView = UIStackView(axis: .vertical, arrangedSubViews: [cameraBtn, cameraLabel], spacing: 20, alignment: .center, distribution: .fillEqually)
        
        cameraBtn.addTarget(self, action: #selector(openDocumentScanner), for: .touchUpInside)
    }
    
    func setupGallery() {
        galleryBtn = Button(image: UIImage(systemName: "photo.fill.on.rectangle.fill"), text: "", btnTitleColor: .clear, backgroundColor: UIColor(named: "whiteColor")!, radius: 0, imageColor: UIColor(named: "blackColor")!)
        galleryLabel = Label(label: "Gallery", textColor: UIColor(named: "whiteColor")!, font: UIFont.systemFont(ofSize: 16, weight: .bold))
        galleryStackView = UIStackView(axis: .vertical, arrangedSubViews: [galleryBtn, galleryLabel], spacing: 20, alignment: .center, distribution: .fillEqually)
        
        galleryBtn.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
    }
    
    func setupFiles() {
        filesBtn = Button(image: UIImage(systemName: "folder.fill"), text: "", btnTitleColor: .clear, backgroundColor: UIColor(named: "whiteColor")!, radius: 0, imageColor: UIColor(named: "blackColor")!)
        filesLabel = Label(label: "Files", textColor: UIColor(named: "whiteColor")!, font: UIFont.systemFont(ofSize: 16, weight: .bold))
        filesStackView = UIStackView(axis: .vertical, arrangedSubViews: [filesBtn, filesLabel], spacing: 20, alignment: .center, distribution: .fillEqually)
        
        filesBtn.addTarget(self, action: #selector(openFiles), for: .touchUpInside)
    }
    
    func setupParentStackView() {
        parentStackView = UIStackView(axis: .horizontal, arrangedSubViews: [cameraStackView, galleryStackView, filesStackView], spacing: 50, alignment: .center, distribution: .fillEqually)
        self.addSubview(parentStackView)
        NSLayoutConstraint.activate([
            parentStackView.bottomAnchor.constraint(equalTo: self.floatingBtn.topAnchor, constant: -30),
            parentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            parentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
        ])
    }
    
    // MARK: -
    func addFloatingBtn() {
        guard tabBarController != nil else {
            print("tabBarController is nil")
            return
        }
        floatingBtn = UIButton()
        floatingBtn.translatesAutoresizingMaskIntoConstraints = false
        floatingBtn.setupButton(background: UIColor(named: "blueColor")!, cornerRadius: 25, img: UIImage(systemName: "xmark"))
        self.addSubview(floatingBtn)
        
        NSLayoutConstraint.activate([
            floatingBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            floatingBtn.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -18),
        ])
        floatingBtn.addTarget(self, action: #selector(dismissOverlay), for: .touchUpInside)
        self.bringSubviewToFront(floatingBtn)
    }
    
    @objc func dismissOverlay() {
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions -
extension TransparentView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @objc func openDocumentScanner() {
        let documentCameraVC = VNDocumentCameraViewController()
        documentCameraVC.delegate = self
        
        if let vc = self.parentViewController() {
            vc.present(documentCameraVC, animated: true)
        }
    }
    
    @objc func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            if let viewController = self.parentViewController() {
                viewController.present(imagePicker, animated: true)
            } else {
                print("photo library is not available")
            }
        }
    }
    
    @objc func openFiles() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        if let tabBarController = self.tabBarController {
            tabBarController.present(documentPicker, animated: true)
        } else {
            print("Error: ")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let fileName = "Gallery\(UUID().uuidString)"
            
            if let pdfURL = convertImageToPDF(image: image, fileName: fileName) {
                delegate?.didSelectFile(url: pdfURL)
                
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 1
                }
                self.removeFromSuperview()
            } else {
                print("Failed to convert image to pdf")
            }
        }
        picker.dismiss(animated: true) {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print("Selected file URL: \(urls.first?.absoluteString ?? "None")")
        guard let selectedFileUrl = urls.first else {
            controller.dismiss(animated: true)
            return
        }
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationUrl = documentDirectory.appendingPathComponent(selectedFileUrl.lastPathComponent)
            
            guard selectedFileUrl.startAccessingSecurityScopedResource() else {
                print("Failed to access security scope")
                controller.dismiss(animated: true)
                return
            }
            
            try? fileManager.removeItem(at: destinationUrl) // Remove if exists
            try fileManager.copyItem(at: selectedFileUrl, to: destinationUrl)
            print("File saved to: \(destinationUrl.path)")
            
            selectedFileUrl.stopAccessingSecurityScopedResource()
            
            // Notify FilesViewController via delegate
            delegate?.didSelectFile(url: destinationUrl)
            
            // Switch to Files tab and dismiss TransparentView
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 1
            }
            self.removeFromSuperview()
        } catch {
            print("Error saving file: \(error.localizedDescription)")
        }
        controller.dismiss(animated: true)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("File picker was cancelled")
        controller.dismiss(animated: true)
    }
}

// MARK: - Extensions -
extension TransparentView: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        
        let scannedImages = (0..<scan.pageCount).compactMap({ scan.imageOfPage(at: $0)})
        
        let fileName = "Scan- \(UUID().uuidString).pdf"
        
        if let pdfURL = convertImagesToPDF(images: scannedImages, fileName: fileName) {
            delegate?.didSelectFile(url: pdfURL)
            
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 1
            }
            self.removeFromSuperview()
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

// MARK: - Extensions -
extension TransparentView {
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
    
    func convertImagesToPDF(images: [UIImage], fileName: String) -> URL? {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        
        do {
            let docDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let pdfURL = docDirectory.appendingPathComponent(fileName).appendingPathExtension("pdf")
            
            let data = pdfRenderer.pdfData { context in
                for image in images {
                    context.beginPage()
                    
                    let aspectRatio = min(612 / image.size.width, 792 / image.size.height)
                    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                    let scaleSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)
                    let imageRect = CGRect(x: (612 - scaleSize.width) / 2, y: (792 - scaleSize.height) / 2, width: scaleSize.width, height: scaleSize.height)
                    image.draw(in: imageRect)
                }
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
