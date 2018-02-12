//
//  PhotoCell.swift
//  Weather
//
//  Created by SteveLin on 2018/2/12.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let identifer = "PhotoCell"
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var ckeckmark: UIImageView!
    
    var isCheckmarked: Bool = false
    var representedAssetIdentifier: String!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = nil
    }
    
    func flipCheckmark() {
        isCheckmarked = !isCheckmarked
    }
    
    func selected() {
        flipCheckmark()
        setNeedsDisplay()
        UIView.animate(withDuration: 0.2) { [weak self] in
            if let isCheckmarked = self?.isCheckmarked {
                self?.ckeckmark.alpha = isCheckmarked ? 1 : 0
            }
        }
    }
    
}
