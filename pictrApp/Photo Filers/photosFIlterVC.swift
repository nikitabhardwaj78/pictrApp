//
//  photosFIlterVC.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 5/2/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class PhotoEditorViewController:
    UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    var originalImage = UIImage()
    var imageTobePassed = UIImage()
    var passedImage = UIImage()
    var thumbnailImage: CIImage!
    var thumbnailImages: [UIImage] = []
    var previewImage: UIImage!
    var previewedPhotoIndexPath: IndexPath!
    var ciContext = CIContext(options: nil)
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    let filters: [(name: String, applier: FilterApplierType?)] = [
        (name: "Normal",
         applier: nil),
        //        (name: "Nashville",
        //         applier: ImageHelper.applyNashvilleFilter),
        (name: "Toaster",
         applier: ImageHelper.applyToasterFilter),
        (name: "1977",
         applier: ImageHelper.apply1977Filter),
        (name: "Clarendon",
         applier: ImageHelper.applyClarendonFilter),
        (name: "HazeRemoval",
         applier: ImageHelper.applyHazeRemovalFilter),
        (name: "Chrome",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectChrome")),
        (name: "Fade",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectFade")),
        (name: "Instant",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectInstant")),
        (name: "Mono",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectMono")),
        (name: "Noir",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectNoir")),
        (name: "Process",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectProcess")),
        (name: "Tonal",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTonal")),
        (name: "Transfer",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTransfer")),
        (name: "Tone",
         applier: ImageHelper.createDefaultFilterApplier(name: "CILinearToSRGBToneCurve")),
        (name: "Linear",
         applier: ImageHelper.createDefaultFilterApplier(name: "CISRGBToneCurveToLinear")),
        ]
    
    
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet var filterCollection: UICollectionView!
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: preview.bounds.width * scale,
                      height: preview.bounds.height * scale)
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        self.imageTobePassed = previewImage
        self.preview.image = self.previewImage
        let fadeView:UIView = UIView()
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.4
        
        self.view.addSubview(fadeView)
        
        self.view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        
        
        let startTime = getStartTime()
        
        self.thumbnailImages = self.filters.map({ (name, applier) -> UIImage in
            let startTime = getStartTime()
            
            if applier == nil {
                return UIImage(ciImage: self.thumbnailImage)
            }
            let uiImage = self.applyFilter(
                applier: applier,
                ciImage: self.thumbnailImage)
            
            printElapsedTime(title:"viewDidLoad\(name)", startTime: startTime)
            
            return uiImage
        })
        
        printElapsedTime(title: "viewDidload", startTime: startTime)
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.filterCollection.reloadData()
                self.filterCollection.alpha = 1
                fadeView.removeFromSuperview()
                self.activityView.stopAnimating()
            }, completion: nil)
        }
  }

    deinit {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numRow: Int = 4
        let cellWidth:CGFloat = self.view.bounds.width / CGFloat(numRow) - CGFloat(numRow)
        let cellHeight: CGFloat = CGFloat(120.0)
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    // return num items
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    // return number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // return cell
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let startTime = getStartTime()
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        let cell: FilterCell = (collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FilterCell.self),for: indexPath) as? FilterCell)!
        activityView.center = CGPoint(x: cell.contentView.frame.size.width / 2 , y: cell.contentView.frame.size.height / 2)
        
        activityView.startAnimating()
        
        cell.title.text = self.filters[indexPath.item].name
        
        cell.thumbnailImage = self.thumbnailImages[indexPath.item]
        
        printElapsedTime(title:"\(indexPath.item)-cell", startTime: startTime)
        
        return cell
        
    }
    
    // cell is selected
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        
        self.previewedPhotoIndexPath = indexPath
        
        if indexPath.item != 0 {
            let startTime = getStartTime()
            
            self.preview.image = self.applyFilter(
                at: indexPath.item, image: self.previewImage)
            self.imageTobePassed = self.preview.image!
            printElapsedTime(title:"selected-\(self.filters[indexPath.item].name)", startTime: startTime)
            
        } else {
            self.preview.image = self.previewImage
        }
    }
    
    
    
    func applyFilter(applier: FilterApplierType?, ciImage: CIImage) -> UIImage {
        
        
        let outputImage: CIImage? = applier!(ciImage)
        
        let outputCGImage = self.ciContext.createCGImage(
            (outputImage)!,
            from: (outputImage?.extent)!)
        return UIImage(cgImage: outputCGImage!)
        
    }
    
    func applyFilter(applier: FilterApplierType?, image: UIImage) -> UIImage {
        let ciImage: CIImage? = CIImage(image: image)
        return applyFilter(applier: applier, ciImage: ciImage!)
    }
    
    func applyFilter(at: Int, image: UIImage) -> UIImage {
        let applier: FilterApplierType? = self.filters[at].applier
        return applyFilter(applier: applier, image: image)
    }
    // MARK: Filter
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? shareVC else {
            fatalError("unexpected view controller for segue")
        }
        //   destination.originalImage_Passed = originalImage
        destination.filteredImage_passed = imageTobePassed
        
    }
}
