//
//  PhotoCollectionViewController.swift
//  Weather
//
//  Created by SteveLin on 2018/2/12.
//  Copyright © 2018年 alin. All rights reserved.
//

import UIKit
import Photos
import RxSwift


class PhotoCollectionViewController: UICollectionViewController {
    
    fileprivate lazy var photos = PhotoCollectionViewController.loadPhotos()
    fileprivate lazy var imageManager = PHCachingImageManager()
    fileprivate lazy var thumbnailsize: CGSize = {
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        return CGSize(width: cellSize.width * UIScreen.main.scale,
                      height: cellSize.height * UIScreen.main.scale)
    }()
    
    fileprivate let selectedPhotosSubject = PublishSubject<UIImage>()
    var selectedPhotos: Observable<UIImage> {
        return selectedPhotosSubject.asObserver()
    }
    let bag = DisposeBag()

}

// delegate and datasource
extension PhotoCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let asset = photos.object(at: indexPath.item)
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCell.identifer, for: indexPath) as! PhotoCell
        
        cell.representedAssetIdentifier = asset.localIdentifier
        
        imageManager.requestImage(for: asset,
                                  targetSize: thumbnailsize,
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: { (image, _) in
                                    guard let image = image else { return }
                                    
                                    if cell.representedAssetIdentifier == asset.localIdentifier {
                                        cell.photo.image = image
                                    }
        }
        )
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let asset = photos.object(at: indexPath.item)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.selected()
        }
        
        imageManager.requestImage(for: asset,
                                  targetSize: view.frame.size,
                                  contentMode: .aspectFill,
                                  options: nil,
                                  resultHandler: { [weak self] (image, info) in
                                    guard let image = image, let info = info else { return }

                                    if let isthumb = info[PHImageResultIsDegradedKey] as? Bool,
                                        !isthumb {
                                        self?.selectedPhotosSubject.onNext(image)
                                    }
        })
    }
}


// controller life circle
extension PhotoCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellSpace()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedPhotosSubject.onCompleted()
    }
}

extension PhotoCollectionViewController {
    func setCellSpace() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let h = (width - 40) / 4
        layout.itemSize = CGSize(width: h, height: h)
        collectionView?.collectionViewLayout = layout
    }
}

// Photo library
extension PhotoCollectionViewController {
    
    static func loadPhotos() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return PHAsset.fetchAssets(with: options)
    }
    
    func photoStatusManage() {
        
        let isAuthorized = PHPhotoLibrary.isAuthorized.share()
        // true
        isAuthorized
            .skipWhile { $0 == false }
            .take(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{
                [weak self] _ in
                if let `self` = self {
                    self.photos = PhotoCollectionViewController.loadPhotos()
                    self.collectionView?.reloadData()
                }
            }).disposed(by: bag)
        // false
        isAuthorized
            .distinctUntilChanged()
            .take(1)
            .filter(!)
            .subscribe(onNext: { _ in
                self.flash(title: "Cannot access your photo library",
                           message: "You can authorize access from the Settings.",
                           callback: { _ in
                            self.navigationController?.popViewController(animated: true)
                })
            }).disposed(by: bag)
    }
}
