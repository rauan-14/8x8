//
//  ViewController.swift
//  8x8
//
//  Created by Rauan Zhakypbek on 1/31/18.
//  Copyright © 2018 Rauan Zhakypbek. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreboardStackView: UIStackView!
    @IBOutlet weak var xScore: UILabel!
    @IBOutlet weak var oScore: UILabel!
    @IBOutlet weak var matchCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var restartButtonHeightContraint: NSLayoutConstraint!
    
    private var gameInfo = GameInfo(matchNumber: 1, matchesOWon: 0, matchesXWon: 0, gameStatus: .xTurn) {
        didSet {
            if statusLabel != nil {
                statusLabel.text = gameInfo.gameStatus.rawValue
            }
            if xScore != nil {
                xScore.text = "X: \(gameInfo.matchesXWon)"
            }
            if oScore != nil {
                oScore.text = "O: \(gameInfo.matchesOWon)"
            }
            if matchCountLabel != nil {
                matchCountLabel.text = "Match #\(gameInfo.matchNumber)"
            }
        }
    }
    
    
    private func updateGameInfo() {
        // Game Checker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.changeCornerRadius(to: 5)
        xScore.changeCornerRadius(to: 5)
        oScore.changeCornerRadius(to: 5)
        matchCountLabel.changeCornerRadius(to: 5)
        restartButton.changeCornerRadius(to: 5)
        restartButtonHeightContraint.constant = 1.5 * cellWidth
        restartButton.layoutIfNeeded()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! MarkCollectionViewCell
        cell.changeCornerRadius(to: 3)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MarkCollectionViewCell, cell.wasMarked == false {
            if gameInfo.gameStatus == .oTurn {
                cell.mark = .o
            }
            else if gameInfo.gameStatus == .xTurn {
                cell.mark = .x
            }
            cell.wasMarked = true
            gameInfo.changeToNextTurn()
        }
    }
    
    struct Constants {
        static let cellOffset:CGFloat = 5
        static let cellIdentifier = "markCell"
    }
    
    var cellWidth: CGFloat {
        return (collectionView.frame.width - 9 * Constants.cellOffset) / 8
    }
}

extension UIView {
    func changeCornerRadius(to radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}


struct GameInfo {
    var matchNumber: Int
    var matchesOWon: Int
    var matchesXWon: Int
    var gameStatus: GameStatus
    mutating func changeToNextTurn() {
        if gameStatus == .xTurn {
           gameStatus = .oTurn
        }
        else if gameStatus == .oTurn {
            gameStatus = .xTurn
        }
    }
}

enum GameStatus: String {
    case oTurn = "O's turn"
    case xTurn = "X's turn"
    case xWon = "X won"
    case oWon = "O won"
    case draw = "Draw"
}
