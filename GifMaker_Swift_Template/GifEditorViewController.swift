//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Carl Lee on 1/26/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController, UITextFieldDelegate {

    // MARK: IBOUTLETS

    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var gifImageView: UIImageView!


    // MARK: IBACTIONS

    @IBAction func presentPreview(_ sender: Any) {

        // Create preview
        let previewVC = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as? PreviewViewController

        // Dependency inject the savedGifsViewController into
        // the preview view controller
        previewVC?.delegate = savedGifsViewController

        // Prepare gif and dependency inject it into new viewcontroller
        // Link all the parts that make up gif and then inject it into the view controlelr
        
        gif?.caption = captionTextField.text
        if let videoURL = gif?.videoURL,
            let gifURL = Regift(sourceFileURL: videoURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount).createGif(caption: captionTextField.text, font: captionTextField.font) {
            let newGif = Gif(url: gifURL, videoURL: videoURL, caption: captionTextField.text)
            previewVC?.gif = newGif
        }

        // Push preview view controller
        if let previewVC = previewVC {
            navigationController?.pushViewController(previewVC, animated: true)
        }
    }


    // MARK: VARIABLES

    // Dependency Injected Variables
    var gif:Gif?
    var savedGifsViewController: PreviewViewControllerDelegate?


    // MARK: FUNCTIONS

    // MARK: VIEW LIFE CYCLE METHODS

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()

        // Turn off the activitiy indicator in the root view because the 
        // video conversion process is complete.
        navigationController?.viewControllers[0].shutdownActivityIndicator()

    }


    override func viewDidLoad() {

            // Create a backbutton that will override the title in the next pushed on view
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

            // Set caption properties
            captionTextField.delegate = self
            gifImageView.image = gif?.gifImage
            let textAttributes: Dictionary = [
                NSStrokeColorAttributeName : UIColor.black,
                NSStrokeWidthAttributeName : -4.0,
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
                ] as [String : Any]
            captionTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
            captionTextField.defaultTextAttributes = textAttributes
            captionTextField.textAlignment = .center
            captionTextField.attributedPlaceholder =
            NSAttributedString(string: "Add Caption",
                               attributes: [
                NSStrokeWidthAttributeName: -4.0,
                NSForegroundColorAttributeName : UIColor.white,
                NSStrokeColorAttributeName : UIColor.black,
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
                ]
            )

            // Always show the navigation bar on this screen
            navigationController?.navigationBar.isHidden = false
    }


    override func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }


    // MARK: TEXT FIELD EDITING METHODS

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension GifEditorViewController {

    // MARK: KEYBOARD ELEVEVATING METHODS

    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(GifEditorViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GifEditorViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }


    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }


    func keyboardWillShow(notification: NSNotification){
        if (view.frame.origin.y >= 0){
            var rect = view.frame
            rect.origin.y -= getKeyboardHeight(notification: notification)
            view.frame = rect
        }
    }


    func keyboardWillHide(notification: NSNotification){
        if (view.frame.origin.y < 0){
            var rect = view.frame
            rect.origin.y += getKeyboardHeight(notification: notification)
            view.frame = rect
        }
    }


    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize: NSValue? = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue
        return keyboardSize?.cgRectValue.height ?? 0
    }
    
}
