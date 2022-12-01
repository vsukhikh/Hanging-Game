//
//  TableViewController.swift
//  Hanging Game
//
//  Created by Vladimir Sukhikh on 2022-11-30.
//

import UIKit

class TableViewController: UITableViewController {
    var words = ["RHYTHM", "AVENUE", "AXIOM", "CYCLE", "CRYPT", "PUPPY", "GOSSIP", "MATRIX", "SUBWAY", "FUNNY", "STAFF", "QUEUE", "JELLY", "BUFFALO", "GALAXY"]

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
        cell.textLabel?.text = "\(indexPath.row + 1). " + changeTitleOfWord(words[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Game") as? GameViewController {
            vc.answer = words[indexPath.row]
            vc.indexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
