//
//  ViewController.swift
//  AddTextOnPhoto
//
//  Created by Jason miew on 2/16/16.
//  Copyright © 2016 JasonHan. All rights reserved.
//

import UIKit

class PhotoEditController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // IBOutlet
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var selectToolBar: UIToolbar!
    @IBOutlet weak var topTxtFld: UITextField!
    @IBOutlet weak var bottomTxtFld: UITextField!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    // var
    var newImage: NewImage?
    var contentMode = UIViewContentMode.ScaleAspectFill
    let textAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePickerView.contentMode = contentMode
        
        // check if the device does not have a camera
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        // shareBtn disable
        shareBtn.enabled = false
        
        topTxtFld.defaultTextAttributes = textAttributes
        bottomTxtFld.defaultTextAttributes = textAttributes
        topTxtFld.textAlignment = NSTextAlignment.Center
        bottomTxtFld.textAlignment = NSTextAlignment.Center
        topTxtFld.delegate = self
        bottomTxtFld.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTxtFld.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }


    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        // close the imagePickerContraller automatically after picked an image
        shareBtn.enabled = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if !textField.text!.isEmpty {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func generateNewImage() -> UIImage {
        // hide the toolbar and navigation bar
        toolbar.hidden = true
        navigationController?.navigationBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let editedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show the toolbar and navigation bar
        toolbar.hidden = false
        navigationController?.navigationBar.hidden = false
        
        return editedImage
    }
    
    func saveImage(editedImage: UIImage) {
        
        newImage = NewImage(topTxt: topTxtFld.text!, bottomTxt: bottomTxtFld.text!, image: imagePickerView.image!, editedImage: editedImage)
        
    }

    @IBAction func share(sender: AnyObject) {
        let editedImage = generateNewImage()
        let activityViewController = UIActivityViewController(activityItems: [editedImage], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            if success == true {
                self.saveImage(editedImage)
            }
        }
    }
    
}

