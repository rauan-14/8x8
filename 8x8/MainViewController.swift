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
    
    private var gameInfo = GameInfo() {
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
    
    @IBAction func restart(_ sender: UIButton) {
        gameInfo.reset()
        collectionView.reloadData()
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
        cell.mark = gameInfo.markedCells[indexPath.section][indexPath.row]
        cell.wasMarked = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MarkCollectionViewCell, cell.wasMarked == false {
            if gameInfo.gameStatus == .oTurn {
                cell.mark = .o
                gameInfo.markedCells[indexPath.section][indexPath.row] = .o
            }
            else if gameInfo.gameStatus == .xTurn {
                cell.mark = .x
                gameInfo.markedCells[indexPath.section][indexPath.row] = .x
            }
            cell.wasMarked = true
            gameInfo.updateGameInfo(afterMarkingAt: indexPath)
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
    var markedCells: [[Mark]]
    private var numMarks = 0
    
    init() {
        markedCells = Array<[Mark]>(repeating: Array<Mark>(repeating: Mark.unmarked, count: 8), count: 8)
        matchesOWon = 0
        matchesXWon = 0
        matchNumber = 1
        gameStatus = .xTurn
    }
    
    private mutating func changeToNextTurn() {
        if gameStatus == .xTurn {
           gameStatus = .oTurn
        }
        else if gameStatus == .oTurn {
            gameStatus = .xTurn
        }
    }
    
    private mutating func getWinner() {
        if gameStatus == .oTurn {
            gameStatus = .oWon
        }
        else if gameStatus == .xTurn {
            gameStatus = .xWon
        }
    }
    
    mutating func updateGameInfo(afterMarkingAt indexPath: IndexPath) {
        numMarks += 1
        if numMarks == 64 {
            gameStatus = .draw
            return
        }
        let section = indexPath.section
        let row =  indexPath.row
        let mark = markedCells[section][row]
        //checking horizontally
        let rightOffset:Int = {
            var offsetPosition = row
            while offsetPosition < 7 && markedCells[section][offsetPosition+1] == mark {
                offsetPosition += 1
            }
            return offsetPosition - row
        }()
        let leftOffset:Int = {
            var offsetPosition = row
            while offsetPosition > 0 && markedCells[section][offsetPosition-1] == mark {
                offsetPosition -= 1
            }
            return row - offsetPosition
        }()
        
        if leftOffset+rightOffset >= 4 {
            getWinner()
        }
        //checking vertically
        let topOffset:Int = {
            var offsetPosition = section
            while offsetPosition > 0 && markedCells[offsetPosition-1][row] == mark {
                offsetPosition -= 1
            }
            return section - offsetPosition
        }()
        
        let bottomOffset:Int = {
            var offsetPosition = section
            while offsetPosition < 7 && markedCells[offsetPosition+1][row] == mark {
                offsetPosition += 1
            }
            return offsetPosition - section
        }()
        if topOffset + bottomOffset >= 4 {
            getWinner()
        }
        //checking diagonally
        let rightBottomOffset:Int = {
            var offset = 0
            var offsetSectionPosition = section
            var offsetRowPosition = row
            while offsetRowPosition < 7 && offsetSectionPosition < 7 && markedCells[offsetSectionPosition+1][offsetRowPosition+1] == mark {
                offset += 1
                offsetSectionPosition += 1
                offsetRowPosition += 1
            }
            return offset
        }()
        let leftBottomOffset:Int = {
            var offset = 0
            var offsetSectionPosition = section
            var offsetRowPosition = row
            while offsetRowPosition > 0 && offsetSectionPosition < 7 && markedCells[offsetSectionPosition+1][offsetRowPosition-1] == mark {
                offset += 1
                offsetSectionPosition += 1
                offsetRowPosition -= 1
            }
            return offset
        }()
        let leftTopOffset:Int = {
            var offset = 0
            var offsetSectionPosition = section
            var offsetRowPosition = row
            while offsetRowPosition > 0 && offsetSectionPosition > 0 && markedCells[offsetSectionPosition-1][offsetRowPosition-1] == mark {
                offset += 1
                offsetSectionPosition -= 1
                offsetRowPosition -= 1
            }
            return offset
        }()
        let rightTopOffset:Int = {
            var offset = 0
            var offsetSectionPosition = section
            var offsetRowPosition = row
            while offsetRowPosition < 7 && offsetSectionPosition > 0 && markedCells[offsetSectionPosition-1][offsetRowPosition+1] == mark {
                offset += 1
                offsetSectionPosition -= 1
                offsetRowPosition += 1
            }
            return offset
        }()
        
        if leftTopOffset + rightBottomOffset >= 4 {
            getWinner()
        }
        
        if leftBottomOffset + rightTopOffset >= 4 {
            getWinner()
        }
        changeToNextTurn()
    }
    mutating func reset() {
        gameStatus = .xTurn
        for i in 0..<8 {
            for j in 0..<8 {
                markedCells[i][j] = .unmarked
            }
        }
        matchesOWon = 0
        matchesXWon = 0
        matchNumber = 1
        numMarks = 0
    }
}

enum GameStatus: String {
    case oTurn = "O's turn"
    case xTurn = "X's turn"
    case xWon = "X won"
    case oWon = "O won"
    case draw = "Draw"
}
