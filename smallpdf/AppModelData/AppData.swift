//
//  DataModel.swift
//  smallpdf
//
//  Created by 
//

import Foundation
import UIKit

struct ScanAndCreateData{
    var img: UIImage?
    var label: String
    var backIcon: UIImage?
}

struct CompressData{
    var img: UIImage?
    var label: String
    var backIcon: UIImage?
}

struct OrganizeData{
    var img: UIImage?
    var label: String
    var backIcon: UIImage?
}

struct ConvertFromPDFData{
    var img: UIImage?
    var label: String
    var backIcon: UIImage?
}

struct ConvertToPDFData{
    var img: UIImage?
    var label: String
    var backIcon: UIImage?
}

struct EditAndSignData{
    var img: UIImage?
    var label: String
    var backIcon: UIImage?
}

struct ModalTableViewData {
    var img: UIImage?
    var label: String
}

var scanAndCreateData = [
    ScanAndCreateData(img: UIImage(systemName: "camera"), label: "Scan Document", backIcon: UIImage(systemName: "chevron.right")),
    ScanAndCreateData(img: UIImage(systemName: "photo.on.rectangle"), label: "Create PDF from Gallery", backIcon: UIImage(systemName: "chevron.right"))
]

var compressData = [
    CompressData(img: UIImage(systemName: "arrow.down.right.and.arrow.up.left.rectangle"), label: "Compress PDF", backIcon: UIImage(systemName: "chevron.right")),
    CompressData(img: UIImage(systemName: "arrow.down.right.and.arrow.up.left.rectangle"), label: "Strong Compress", backIcon: UIImage(systemName: "chevron.right"))
]

var organizeData = [
    OrganizeData(img: UIImage(systemName: "plus.square.on.square"), label: "Merge", backIcon: UIImage(systemName: "chevron.right")),
    OrganizeData(img: UIImage(systemName: "square.grid.2x2"), label: "Organize", backIcon: UIImage(systemName: "chevron.right")),
    OrganizeData(img: UIImage(systemName: "trash"), label: "Delete pages", backIcon: UIImage(systemName: "chevron.right")),
    OrganizeData(img: UIImage(systemName: "arrow.trianglehead.clockwise.rotate.90"), label: "Rotate", backIcon: UIImage(systemName: "chevron.right"))
]

var convertFromPDFData = [
    ConvertToPDFData(img: UIImage(systemName: "w.square.fill"), label: "PDF to Word", backIcon: UIImage(systemName: "chevron.right")),
    ConvertToPDFData(img: UIImage(systemName: "x.square.fill"), label: "PDF to Excel", backIcon: UIImage(systemName: "chevron.right")),
    ConvertToPDFData(img: UIImage(systemName: "p.square.fill"), label: "PowerPoint to PDF", backIcon: UIImage(systemName: "chevron.right")),
    ConvertToPDFData(img: UIImage(systemName: "photo.fill"), label: "PDF to Image", backIcon: UIImage(systemName: "chevron.right")),
    ConvertToPDFData(img: UIImage(systemName: "square.fill"), label: "Convert with OCR", backIcon: UIImage(systemName: "chevron.right"))
]

var convertToPDFData = [
    ConvertToPDFData(img: UIImage(systemName: "w.square.fill"), label: "PDF to Word", backIcon: UIImage(systemName: "chevron.right")),
    ConvertToPDFData(img: UIImage(systemName: "x.square.fill"), label: "PDF to Excel", backIcon: UIImage(systemName: "chevron.right")),
    ConvertToPDFData(img: UIImage(systemName: "p.square.fill"), label: "PowerPoint to PDF", backIcon: UIImage(systemName: "chevron.right")),
    ConvertToPDFData(img: UIImage(systemName: "photo.fill"), label: "PDF to Image", backIcon: UIImage(systemName: "chevron.right"))
]

var editAndSignData = [
    EditAndSignData(img: UIImage(systemName: "pencil"), label: "Annotate", backIcon: UIImage(systemName: "chevron.right")),
    EditAndSignData(img: UIImage(systemName: "pencil.and.outline"), label: "Sign", backIcon: UIImage(systemName: "chevron.right"))
]

var modalTableViewData = [
    ModalTableViewData(img: UIImage(systemName: "square.fill"), label: "OCR PDF"),
    ModalTableViewData(img: UIImage(systemName: "pano"), label: "Compress PDF"),
    ModalTableViewData(img: UIImage(systemName: "arrow.up.left.and.arrow.down.right.rectangle"), label: "Convert to"),
    ModalTableViewData(img: UIImage(systemName: "pencil.tip"), label: "eSign PDF"),
    ModalTableViewData(img: UIImage(systemName: "square.and.pencil"), label: "Edit"),
    ModalTableViewData(img: UIImage(systemName: "square.grid.2x2"), label: "Organize pages"),
    ModalTableViewData(img: UIImage(systemName: "square.and.arrow.up"), label: "Share"),
    ModalTableViewData(img: UIImage(systemName: "iphone"), label: "Save to device"),
    ModalTableViewData(img: UIImage(systemName: "icloud.and.arrow.up"), label: "Save to cloud"),
    ModalTableViewData(img: UIImage(systemName: "arrow.trianglehead.rectanglepath"), label: "Rename"),
    ModalTableViewData(img: UIImage(systemName: "trash"), label: "Delete"),
]
