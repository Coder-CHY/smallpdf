//
//  CustomHomeCollectionView.swift
//  smallpdf
//
//  Created by 
//

import UIKit

class CustomHomeCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "CustomHomeCell"
    let layout = UICollectionViewFlowLayout()
    var customDelegate: CustomHomeCollectionViewDelegate?
    
    let itemDataSource: [[Any]] = [
        scanAndCreateData,
        compressData,
        organizeData,
        convertFromPDFData,
        convertToPDFData,
        editAndSignData
    ]
    
    init(frame: CGRect){
        super.init(frame: frame, collectionViewLayout: layout)
        customizeCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Customizing -
    func customizeCollectionView() {
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.collectionViewLayout = layout
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor(named: "whiteColor")!
        self.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.showsVerticalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(CustomHomeCell.self, forCellWithReuseIdentifier: "CustomHomeCell")
        self.register(ScanAndCreateHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ScanAndCreateHeaders.identifier)
        self.register(CompressHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompressHeaders.identifier)
        self.register(OrganizeHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OrganizeHeaders.identifier)
        self.register(ConvertFromPDFHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ConvertFromPDFHeaders.identifier)
        self.register(ConvertToPDFHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ConvertToPDFHeaders.identifier)
        self.register(EditAndSignHeaders.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EditAndSignHeaders.identifier)
    }
    
    func setupLayout(with layout: UICollectionViewLayout) {
        self.collectionViewLayout = layout
    }
    
    // MARK: - UICollectionViewDataSource -
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return itemDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDataSource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomHomeCell", for: indexPath) as! CustomHomeCell
        cell.backgroundColor = UIColor(named: "whiteColor")!
        cell.addShadow()
        let data = itemDataSource[indexPath.section][indexPath.item]
        cell.configure(with: data)
        return cell
    }
    
    //MARK: - DelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 50)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        if indexPath.item == astrologerModel.count - 1 {
    //            fetchAstrologersData()
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customDelegate?.didSelectItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch indexPath.section {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ScanAndCreateHeaders.identifier, for: indexPath) as! ScanAndCreateHeaders
                header.configure()
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompressHeaders.identifier, for: indexPath) as! CompressHeaders
                header.configure()
                return header
            case 2:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OrganizeHeaders.identifier, for: indexPath) as! OrganizeHeaders
                header.configure()
                return header
            case 3:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ConvertFromPDFHeaders.identifier, for: indexPath) as! ConvertFromPDFHeaders
                header.configure()
                return header
            case 4:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ConvertToPDFHeaders.identifier, for: indexPath) as! ConvertToPDFHeaders
                header.configure()
                return header
            case 5:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EditAndSignHeaders.identifier, for: indexPath) as! EditAndSignHeaders
                header.configure()
                return header
            default:
                break
            }
        }
        return UICollectionReusableView()
    }
}
