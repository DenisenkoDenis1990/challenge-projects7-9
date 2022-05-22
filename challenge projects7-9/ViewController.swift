//
//  ViewController.swift
//  challenge projects7-9
//
//  Created by Denys Denysenko on 28.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel : UILabel!
    var textField: UITextField!
    var letterButtons = [UIButton]()
    var livesCount: UILabel!
    var tappedLetter = [String]()
    var answer = ""
    var score = 0 {
        
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }
    var lives = 7 {
        
        didSet {
            livesCount.text = "LIVES REMAINING: \(lives)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "SCORE: 0"
        scoreLabel.textAlignment = .left
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        scoreLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(scoreLabel)
        
        livesCount = UILabel()
        livesCount.translatesAutoresizingMaskIntoConstraints = false
        livesCount.text = "LIVES REMAINING: 7"
        livesCount.textAlignment = .right
        livesCount.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(livesCount)
        
       
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 44)
        textField.textAlignment = .center
        view.addSubview(textField)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1.0
        buttonsView.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
        
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20.0),
            scoreLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            scoreLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5, constant: -100),
            livesCount.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            livesCount.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            livesCount.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5, constant: -100),
            livesCount.heightAnchor.constraint(equalTo: scoreLabel.heightAnchor),
            textField.topAnchor.constraint(equalTo: livesCount.bottomAnchor, constant: 150),
            textField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4),
            textField.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 200),
            buttonsView.widthAnchor.constraint(equalToConstant: 780),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        
        ])
        
        let width = 60
        let height = 100
        
        for row in 0..<2 {
            for column in 0..<13 {
                
                let letterButton = UIButton(type: .system)
                letterButton.setTitle("+", for: .normal)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
        
    }
    
    func loadLevel() {
        
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        if alphabet.count == letterButtons.count {
            
            for (index, char) in alphabet.enumerated() {
                
                letterButtons[index].setTitle(String(char), for: .normal)
                letterButtons[index].isHidden = false
            }
        }
        
        let answerFileURL = Bundle.main.url(forResource: "sports", withExtension: "txt")
        let levelcContent = try? String(contentsOf: answerFileURL!)
        let answers = levelcContent!.components(separatedBy: "\n")
         answer = answers.randomElement()!
        for _ in answer.indices {
            
            textField.text?.append("?")
        }
        
    }

    @objc func letterTapped (_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else {return}
        tappedLetter.append(buttonTitle)
        
        var typedWord = ""
        for char in answer {
            
            if tappedLetter.contains(String(char)) {
                typedWord.append(char)
                
            
                
            } else {
                typedWord.append("?")
                
            }
           
            
        }
        
        if typedWord.contains(buttonTitle) {
            score += 1
        }else {
            lives -= 1
        }
        
        textField.text = typedWord
        sender.isHidden = true
        
        if lives == 0 {
            let ac = UIAlertController(title: "You lose", message: "No lives remaining", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default, handler: tryAgain))
            present(ac, animated: true)
            
        }
        
        if !typedWord.contains("?") {
            let ac = UIAlertController(title: "Well done", message: "Your score is \(score). Get ready to the next level", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Next Level", style: .default, handler: levelUp))
            present(ac, animated: true)
        }
    }
    
    func tryAgain (action: UIAlertAction) {
        score = 0
        lives = 7
        textField.text?.removeAll()
        tappedLetter.removeAll()
        loadLevel()
    }
    
    func levelUp (action: UIAlertAction) {
        lives = 7
        textField.text?.removeAll()
        tappedLetter.removeAll()
        loadLevel()
    }

}

