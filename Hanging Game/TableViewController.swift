//
//  TableViewController.swift
//  Hanging Game
//
//  Created by Vladimir Sukhikh on 2022-11-30.
//

import UIKit

class TableViewController: UITableViewController {
    var words = ["RHYTHM", "AVENUE", "AXIOM", "CYCLE", "CRYPT", "PUPPY", "GOSSIP", "MATRIX", "SUBWAY", "FUNNY", "STAFF", "QUEUE", "JELLY", "BUFFALO", "GALAXY"]
    
    var userWords = Array(repeating: "", count: 15)
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "userWords") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                userWords = try jsonDecoder.decode([String].self, from: savedData)
            } catch {
                print("Failed to load words.")
            }
        }
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hanging Game"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func changeTitleOfWord(_ word: String) -> String {
        var str = ""
        for _ in word {
            str += "?"
        }
        
        return str
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        if userWords[indexPath.row] != "" {
            cell.textLabel?.text = "\(indexPath.row + 1). " + userWords[indexPath.row]
        } else {
            cell.textLabel?.text = "\(indexPath.row + 1). " + changeTitleOfWord(words[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Game") as? GameViewController {
            vc.answer = words[indexPath.row]
            vc.indexPath = indexPath
            vc.userWords = userWords
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
