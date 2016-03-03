//
//  File.swift
//  AddTextOnPhoto
//
//  Created by Jason miew on 2/18/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import Foundation
import UIKit

struct NewImage {
    private var _topTxt: String!
    private var _bottomTxt: String!
    private var _image: UIImage!
    private var _editedImage: UIImage!
    
    var topTxt: String {
        get {
            return _topTxt
        }
    }
    
    var bottomTxt: String {
        get {
            return _bottomTxt
        }
    }
    
    var image: UIImage {
        get {
            return _image
        }
    }
    
    var editedImage: UIImage {
        get {
            return _editedImage
        }
    }
    
    init (topTxt: String, bottomTxt: String, image: UIImage, editedImage: UIImage) {
        self._topTxt = topTxt
        self._bottomTxt = bottomTxt
        self._image = image
        self._editedImage = editedImage
    }
}