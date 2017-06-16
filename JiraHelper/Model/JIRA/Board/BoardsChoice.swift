//
//  BoardsChoice.swift
//  JiraHelper
//
//  Created by Kacper Harasim on 16/06/2017.
//  Copyright © 2017 Kacper Harasim. All rights reserved.
//

import Foundation

struct BoardsChoice {
    let selected: Board
    let rest: [Board]

    init?(boards: [Board]) {
        guard let (head, tail) = boards.decomposed() else { return nil }
        self.selected = head
        self.rest = tail
    }
}
