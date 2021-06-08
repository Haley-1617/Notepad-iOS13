//
//  ContentViewController.swift
//  Notepad
//
//  Created by Haley Lai on 6/8/21.
//

import UIKit
import CoreData

class ContentViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedNote: Note?
    
    @IBOutlet weak var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.title = selectedNote!.title
        textView?.text = selectedNote?.content
        checkEmpty()
        textView?.delegate = self
    }
    
    func checkEmpty() {
        if (textView?.text == "") {
            textView?.text = "Type Something..."
            textView?.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        selectedNote?.content = textView?.text
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
}

//MARK: - UITextViewDelegate Methods

extension ContentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.textColor == UIColor.lightGray) {
            textView.text = nil
            textView.textColor = UIColor.black
        } else {
            print("textView is not lightGray")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        checkEmpty()
    }
}
