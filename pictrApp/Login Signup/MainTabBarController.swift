//
//  MainTabBarController.swift
//  pictrApp
//
//  Created by Nikita Bhardwaj on 4/5/18.
//  Copyright © 2018 Nikita Bhardwaj. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
delegate = self
        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = .black
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            // present photo taking action sheet
            print("take photo")
            
            return false
        } else {
            return true
        }
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

