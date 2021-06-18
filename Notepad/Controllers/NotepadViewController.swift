//
//  ViewController.swift
//  Notepad
//
//  Created by Haley Lai on 6/7/21.
//

import UIKit
import CoreData

class NotepadViewController: UITableViewController {
    
    var notes = [Note]()
    
    var selectedCategory : Category? {
        didSet {
            loadNotes()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.name
        
//        print(UIAlertAction.propertyNames)
//        print(dataFilePath)
    }
    
    //MARK: - UITableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotepadCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToContent", sender: self)
    }
    
    //MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ContentViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notes[indexPath.row]
        }
        destinationVC.navigationItem.backButtonTitle = "Back"
    }
    
    //MARK: - Alert Action Handler
    
    @IBAction func showEditMenu(_ gestureRecognizer: UILongPressGestureRecognizer) {
        // long press detected
        if (gestureRecognizer.state == .began) {
            let touchPoint = gestureRecognizer.location(in: tableView)
            // non empty cell is pressed
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                // delete action and button in alert popup
                let alert = UIAlertController(title: "\"\(notes[indexPath.row].title!)\"", message: "", preferredStyle: .alert)
                // alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
                // action.setValue(UIColor.green, forKey: "titleTextColor")
                // }))
                let editAction = UIAlertAction(title: "Edit", style: .default, handler: nil)
                editAction.setValue(UIColor.systemGreen, forKey: "titleTextColor")
                alert.addAction(editAction)
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    self.context.delete(self.notes[indexPath.row])
                    self.notes.remove(at: indexPath.row)
                    self.saveNote()
                }))
                // Cancel button in alert popup
                // alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                present(alert, animated: true) {
                    // dismiss window when tap outside
                    alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
                }
            }
        }
    }
    
    @objc func dismissAlert(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Add New Note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // alert view
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new note"
            textField = alertTextField
        }
        
        // button in alert view
        let action = UIAlertAction(title: "New Note", style: .default) { (action) in
            if let title = textField.text {
                let newNote = Note(context: self.context)
                newNote.title = title
                newNote.content = ""
                newNote.createdDate = Date()
                newNote.parentCategory = self.selectedCategory
                self.notes.append(newNote)
                self.saveNote()
            } else {
                print("Error adding new note")
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveNote() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching notes, \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - UIAlertAction Property Getter
//  get all available properties of UIAlertAction
extension UIAlertAction {
    static var propertyNames: [String] {
        var outCount: UInt32 = 0
        guard let ivars = class_copyIvarList(self, &outCount) else {
            return []
        }
        var result = [String]()
        let count = Int(outCount)
        for i in 0..<count {
            let pro: Ivar = ivars[i]
            guard let ivarName = ivar_getName(pro) else {
                continue
            }
            guard let name = String(utf8String: ivarName) else {
                continue
            }
            result.append(name)
        }
        return result
    }
}
