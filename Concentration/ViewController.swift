//
//  ViewController.swift
//  Concentration
//
//  Created by Ankur Oberoi on 11/21/17.
//  Copyright © 2017 Ankur Oberoi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private let labelAttributes: [NSAttributedStringKey:Any] = [
        .strokeWidth : 5.0,
        .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),
    ];
    
    private func updateFlipCountLabel() {
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: labelAttributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreLabel() {
        let attributedString = NSAttributedString(string: "Score: \(game.score)", attributes: labelAttributes)
        scoreLabel.attributedText = attributedString
    }

    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func newGameTapped() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emojiChoices = generateEmojiChoices()
        theme = pickRandomTheme()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        updateFlipCountLabel()
        updateScoreLabel()
    }
    
    private lazy var theme = pickRandomTheme()
    
    private func pickRandomTheme() -> String {
        let themes = Array(emojiChoices.keys)
        return themes[themes.count.arc4random]
    }
    
    private lazy var emojiChoices: [String:String] = generateEmojiChoices()
    
    private func generateEmojiChoices() -> [String:String] {
        return [
            "halloween": "🦇😱🙀😈🎃👻🍭🍬🍎",
            "sports": "⚽️🏀🏈🎾🏒🎳🏆🏄🏌️⚾️",
            "faces": "😀🙃😍🤡😎☹️🤔😴😡",
            "travel": "🚗🛴🚎🚃🚀✈️🚂🏎🚤",
            "food": "🍪🍩🍣🥗🍟🌮🍔🌭🍕🥞🍳",
            "animals": "🐶🐱🦁🐰🐷🐵🐔🐴🐍🐟🐙"
        ];
    };
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        var emojiChoices = self.emojiChoices[theme]!
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            self.emojiChoices[theme] = emojiChoices
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
