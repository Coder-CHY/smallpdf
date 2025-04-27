//
//  Extension.swift
//  smallpdf
//
//  Created by 
//

import Foundation
import UIKit
import PDFKit

// MARK: - Reusable Extension Views -
extension UIView {
    func addShadow() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowOpacity = 1
    }
}

extension UIButton {
    func setupButton(background: UIColor, cornerRadius: CGFloat, img: UIImage?) {
        self.backgroundColor = background
        self.layer.cornerRadius = cornerRadius
        self.setImage(img, for: .normal)
        self.tintColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension UIView {
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension String {
    //MARK: -
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    //MARK: -
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`']{6,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: self)
    }
}

struct PDFConverter {
    static func convertImagesToPDF(images: [UIImage], fileName: String) -> URL? {
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
    
    static func convertImageToPDF(image: UIImage, fileName: String) -> URL? {
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

struct PDFProcessor {
    static func mergePDFs(at inputURLs: [URL], outputName: String) throws -> URL {
        let fileManager = FileManager.default
        let docDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let outputURL = docDirectory.appendingPathComponent(outputName)
        
        guard !fileManager.fileExists(atPath: outputURL.path) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ""])
        }
        
        let mergedDocument = PDFDocument()
        var currentPageIndex = 0
        
        for inputURL in inputURLs {
            guard let document = PDFDocument(url: inputURL) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ""])
            }
            
            for pageIndex in 0..<document.pageCount {
                guard let page = document.page(at: pageIndex) else {continue}
                mergedDocument.insert(page.copy() as! PDFPage, at: currentPageIndex)
                currentPageIndex += 1
            }
        }
        guard mergedDocument.write(to: outputURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ""])
        }
        
        if let attributes = try? fileManager.attributesOfItem(atPath: outputURL.path),
           let fileSize = attributes[.size] as? Int64 {
            print("\(fileSize)")
        }
        return outputURL
    }
    static func deletePages(from inputURL: URL, pagesToDelete: [Int], outputName: String) throws -> URL {
        guard let document = PDFDocument(url: inputURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ""])
        }
        
        let fileManager = FileManager.default
        let docDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let outputURL = docDirectory.appendingPathComponent(outputName)
        
        guard !fileManager.fileExists(atPath: outputURL.path) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ""])
        }
        
        let newDocument = PDFDocument()
        var newPageIndex = 0
        
        for pageIndex in 0..<document.pageCount {
            if !pagesToDelete.contains(pageIndex) {
                guard let page = document.page(at: pageIndex) else { continue }
                newDocument.insert(page.copy() as! PDFPage, at: newPageIndex)
                newPageIndex += 1
            }
        }
        guard newDocument.write(to: outputURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: ""])
        }
        
        if let attributes = try? fileManager.attributesOfItem(atPath: outputURL.path),
           let fileSize = attributes[.size] as? Int64 {
            print("\(fileSize)")
        }
        return outputURL
    }
}
