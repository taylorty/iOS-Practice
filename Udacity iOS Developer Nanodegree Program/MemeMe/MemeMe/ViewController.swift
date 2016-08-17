//
//  ViewController.swift
//  MemeMe
//
//  Created by Tongyu on 8/16/16.
//  Copyright © 2016 Tongyu Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    let textDelegate = TextFieldsDelegate()
    
    var ORIGINAL_TOP_TEXT:String = "TOP"
    var ORIGINAL_BOTTOM_TEXT:String = "BOTTOM"
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : NSNumber(float: -3.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextField(topTextField)
        prepareTextField(bottomTextField)
    }
    
    func prepareTextField(textField : UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = textDelegate
        textField.borderStyle = UITextBorderStyle.None
        textField.backgroundColor = UIColor.clearColor()
    }


    func imagePickerController(imagePicker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
            cancelButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Actions
    @IBAction func pickAnImageFromAlbum (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        topTextField.text = ORIGINAL_TOP_TEXT
        bottomTextField.text = ORIGINAL_BOTTOM_TEXT
        shareButton.enabled = false
        imagePickerView.image = nil
        dismissKeyboard()
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        let image = generateImage()
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.completionWithItemsHandler = {activity, success, items, error in
            if (success == true) {
                    self.saveImage(image)
                    activityController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func generateImage() -> UIImage {
        toolBar.hidden = true
        navBar.hidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBar.hidden = false
        navBar.hidden = false
        
        return image
    }
    
    func saveImage(memeImage:UIImage) -> UIImage{
        _ = Meme (topText: topTextField.text, bottomText:bottomTextField.text, image: imagePickerView.image, memeImage:memeImage)
        return memeImage
    }
    
    // Sign up to be notified when the keyboard appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // When the keyboardWillShow notification is received, shift the view's frame up
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            if view.frame.origin.y != 0.0 {
                view.frame.origin.y = 0.0
            }
            else{
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
      // Hide status bar
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
}
