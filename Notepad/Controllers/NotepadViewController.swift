//
//  ViewController.swift
//  Notepad
//
//  Created by Haley Lai on 6/7/21.
//

import UIKit

class NotepadViewController: UITableViewController {
    
    var notes: [String] = ["Work", "Home", "School"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "NotepadCell")
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }

}

