//
//  protocol.swift
//  smallpdf
//
//  Created by 
//

import Foundation

//MARK: - Protocols -
protocol TransparentViewDelegateForFiles {
    func didSelectFile(url: URL)
}

protocol CustomHomeCollectionViewDelegate {
    func didSelectItem(at indexPath: IndexPath)
}

protocol ModalVCDelegate {
    func didRenameFile(from oldURL: URL, to newURL: URL)
    func didDeleteFile(at fileURL: URL)
    func didCompressFile(to newURL: URL)
}

protocol PageSelectionDelegate {
    func didSelectPagesToDelete(_ pages: [Int], forPDF pdfURL: URL)
}
