//
//  ViewController.swift
//  Hanging Game
//
//  Created by Vladimir Sukhikh on 2022-11-30.
//

import UIKit

class GameViewController: UIViewController {
    var currentAnswer: UITextField!
    var letterButtons = [UIButton]()
    var answer: String?
    var activatedButtons = [UIButton]()
    var letters = [Character]()
    var attemptLabel: UILabel!
    
    var indexPath: IndexPath?
    
    var attempt = 0 {
        didSet {
            attemptLabel.text = "Attempt \(attempt)/7"
        }
    }
    
    var userWords: [String]?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        
        // Attemt View
        attemptLabel = UILabel()
        attemptLabel.translatesAutoresizingMaskIntoConstraints = false
        attemptLabel.textAlignment = .right
        attemptLabel.text = "Attempt 0/7"
        view.addSubview(attemptLabel)
        
        // Text Field with Current Answer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // Buttons View
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate ([
            attemptLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 39),
            attemptLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 720),
            buttonsView.heightAnchor.constraint(equalToConstant: 520),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 120
        let heigth = 80
        
        for row in 0..<5 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.backgroundColor = .systemGray6
                letterButton.setTitleColor(.label, for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame: CGRect
                if row == 4 && column >= 2 {
                    continue
                } else {
                    letterButton.setTitle("W", for: .normal)
                }
                
                frame = CGRect(x: column * width, y: row * heigth, width: width - 10, height: heigth - 10)
                letterButton.frame = frame
                
                letterButton.layer.borderWidth = 1.0
                letterButton.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6).cgColor
                letterButton.layer.cornerRadius = 10
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        for letter in UnicodeScalar("A").value...UnicodeScalar("Z").value {
            if UnicodeScalar(letter) != nil {
                letterButtons[Int(letter)-65].setTitle(String(UnicodeScalar(letter)!), for: .normal)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        activatedButtons.append(sender)
        sender.isHidden = true
        
        for (index, letter) in letters.enumerated() {
            if buttonTitle == String(letter) {
                if let str = currentAnswer.text {
                    var chars = Array(str)
                    chars[index] = letter
                    currentAnswer.text = String(chars)
                }
            }
        }
        
        attempt += 1
        
        if currentAnswer.text!.contains("?") {
            if attempt == 7 {
                let ac = UIAlertController(title: "Game Over!", message: "Your word was \(answer ?? "")", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: {_ in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                present(ac, animated: true)
                
                userWords![indexPath!.row] = currentAnswer.text ?? answer!
                save()
                
                hideAllButtons()
            }
        } else {
            let ac = UIAlertController(title: "Yaay!", message: "Ready for the next word?", preferredStyle: .alert)
            //ac.addAction(UIAlertAction(title: "Let's go", style: .default))
            ac.addAction(UIAlertAction(title: "Exit", style: .destructive, handler: {_ in
                _ = self.navigationController?.popViewController(animated: true)
            }))
            present(ac, animated: true)
            
            userWords![indexPath!.row] = currentAnswer.text ?? answer!
            save()
            
            hideAllButtons()
        }
        
            
    }

    func loadLevel() {
        unhideAllButtons()
        currentAnswer.text = ""
        
        if let answer = answer {
            for letter in answer {
                letters.append(letter)
                currentAnswer.text! += "?"
            }
        }
    }
    
    func hideAllButtons() {
        for button in letterButtons {
            button.isHidden = true
        }
    }
    
    func unhideAllButtons() {
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    // MARK: - Save to User Defaults
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(userWords) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "userWords")
        } else {
            print("Failed to save words.")
        }
    }

}

