//
//  searchViewController.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/7/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let array = ["im1","im2","im3","im4","im5","im6","im7","im1","im2","im3","im4","im5","im6","im7","im1","im2","im3","im4","im5","im6","im7","im1","im2","im3","im4","im5","im6","im7","im1","im2","im3","im4","im5","im6","im7","im1","im2","im3","im4","im5","im6","im7","im1","im2","im3","im4","im5","im6","im7"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedsCell", for: indexPath) as! searchCollectionCell
        
        cell.imageView.image = UIImage(named: array[indexPath.row])
        // cell.img_uploaded.image = UIImage(named: arrayimages[indexPath.row])
        // cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2
        // cell.imageView.clipsToBounds = true
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
