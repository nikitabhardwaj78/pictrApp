//
//  shareVC.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 3/8/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import GooglePlaces
import GooglePlacePicker

var upload_dict = [String : String]()

@available(iOS 10.0, *)
class shareVC: UIViewController, CLLocationManagerDelegate {
    var currentUserId = Auth.auth().currentUser?.uid
    var originalImage_Passed = UIImage()
    var filteredImage_passed = UIImage()
    var finalimage = UIImage()
    var temp = [String : String]()
    
    var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    var userLatitude : CLLocationCoordinate2D?
    var userLongitude:CLLocationDegrees! = 0
    var defplaceid = String()
    var location = String()
    
    @IBOutlet var postFb_switch: UISwitch!
    @IBOutlet var savegallery_switch: UISwitch!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var location_lbl: UILabel!
    @IBOutlet weak var txtField_captionForphoto: UITextField!
    @IBOutlet weak var imgview_toBeshared: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgview_toBeshared.image = filteredImage_passed
        imgview_toBeshared.contentMode = .scaleAspectFit
      //  imgview_toBeshared.image = originalImage_Passed
        
        
        imgview_toBeshared.contentMode = .scaleToFill
    
        
        locationManager.requestAlwaysAuthorization()
        placesClient = GMSPlacesClient.shared()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
            
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            
            userLatitude  = locationManager.location?.coordinate
            userLongitude  = locationManager.location?.coordinate.longitude
        }
        savegallery_switch.addTarget(self, action: #selector(switchIsChanged), for: UIControlEvents.valueChanged)
        postFb_switch.addTarget(self, action: #selector(FbswitchIsChanged), for: UIControlEvents.valueChanged)
        
    }
    @objc func FbswitchIsChanged(postFb_switch : UISwitch)
    {
        if postFb_switch.isOn {
        let imageToShare = [imgview_toBeshared.image!,]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
     
        self.present(activityViewController, animated: true, completion: nil)
        
        func completionHandler(activityType: UIActivityType?, shared: Bool, items: [Any]?, error: Error?) {
            
            if !shared{
              
                return
            }
            else{
                let dialogMessage = UIAlertController(title: "Confirm", message: "Shared successfull", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    self.dismiss(animated: true, completion: nil)
                })
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
            }
            
        }
        activityViewController.completionWithItemsHandler = completionHandler
            
    }
        else {
            print("Image Not shared")
            postFb_switch.setOn(false, animated: true)
        }
        
    }
    @objc func switchIsChanged (savegallery_switch : UISwitch)
    {
        if savegallery_switch.isOn {
            
            UIImageWriteToSavedPhotosAlbum(imgview_toBeshared.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
        } else {
            print("Image Not saved")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_postToProfile(_ sender: AnyObject ) {
       
            let location = address_lbl.text ?? " "
            let Caption = txtField_captionForphoto.text ?? " "
            PostService.create(for: imgview_toBeshared.image!)
            let currentUser = User.current
            let ref = Database.database().reference()

            uploadMedia() { url in
                if url != nil {
                    ref.child("locationAndImagecaption").child(currentUser.uid).childByAutoId().setValue([
                        "posterID"      : currentUser.uid,
                        "caption"    : Caption,
                        "myImageURL" : url!,
                        "location" : location
                        ])
                }
            }
        
    tabBarController?.selectedIndex = 0
      self.navigationController?.popToRootViewController(animated: true)
       
    }

    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("images/posts")
        if let uploadData = UIImagePNGRepresentation(self.imgview_toBeshared.image!) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                   
                }
            }
        }
    }
    
    
    
    
    
    @IBAction func addLocation(_ sender: Any) {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print(place.name)
                    self.address_lbl.text = place.name
                    let Location_dict = ["Location" : place.name ]
                    self.location = place.name
                    
                }
            }
        })
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(String(describing: place.formattedAddress))")
                    print("Current Place attributions \(String(describing: place.attributions))")
                    print("Current PlaceID \(place.placeID)")
                }
                
            }
        })
        
    }
    
    
    @IBAction func saveTogallery_switch(_ sender: Any)
    {
        
    }
    
    
    @IBAction func Btn_BackToFilters(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
}

