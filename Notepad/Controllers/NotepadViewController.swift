//
//  ViewController.swift
//  Notepad
//
//  Created by Haley Lai on 6/7/21.
//

import UIKit
import CoreData

class NotepadViewController: UITableViewController {
    
    var notes: [Note] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()
        //        print(dataFilePath)
    }
    
    //MARK: - UITableViewDataSource Methods
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ContentViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notes[indexPath.row]
        }
        destinationVC.navigationItem.backButtonTitle = "Back"
    }
    
    @IBAction func showEditMenu(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == .began) {
            print("long press detected")
            let touchPoint = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                print("Current long-pressed row: \(notes[indexPath.row])")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        //        alert view
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new note"
            textField = alertTextField
        }
        
        //        button in alert view
        let action = UIAlertAction(title: "New Note", style: .default) { (action) in
            if let title = textField.text {
                let newNote = Note(context: self.context)
                newNote.title = title
                newNote.content = ""
                newNote.createdDate = Date()
                self.notes.append(newNote)
                self.saveNote()
            } else {
                print("Error adding new note")
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
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
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
}
