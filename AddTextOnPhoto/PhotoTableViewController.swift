//
//  PhotoTableViewController.swift
//  AddTextOnPhoto
//
//  Created by Jason miew on 3/3/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import UIKit

class PhotoTableViewController: UIViewController {
    
    var editedImages: [NewImage] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).editedImages
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
