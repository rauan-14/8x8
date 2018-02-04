//
//  MarkCollectionViewCell.swift
//  8x8
//
//  Created by Rauan Zhakypbek on 1/31/18.
//  Copyright © 2018 Rauan Zhakypbek. All rights reserved.
//

import UIKit

class MarkCollectionViewCell: UICollectionViewCell {
    var wasMarked = false
    var mark: Mark = .unmarked {
        didSet {
            markView.mark = self.mark
        }
    }
    @IBOutlet weak var markView: MarkView! {
        didSet {
            markView.setNeedsDisplay()
        }
    }
}

enum Mark {
    case x
    case o
    case unmarked
}
