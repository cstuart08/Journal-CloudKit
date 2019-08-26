//
//  EntryViewController.swift
//  Journal-CloudKit
//
//  Created by Apps on 8/26/19.
//  Copyright © 2019 Apps. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
    }
    
    func updateViews() {
        loadViewIfNeeded()
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
    }
    
    @IBAction func clearAllButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if titleTextField.text != "" && bodyTextView.text != "" {
            
            if let entry = entry {
                EntryController.sharedInstance.updateEntries(entry: entry, newTitle: titleTextField.text!, body: bodyTextView.text)
                navigationController?.popViewController(animated: true)
            } else {
                EntryController.sharedInstance.addEntryWith(title: self.titleTextField.text!, body: self.bodyTextView.text) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        } else {
            return
        }
    }
    
}
