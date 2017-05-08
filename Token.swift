//
//  Token.swift
//  Cards
//
//  Created by Anton Eskildsen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Foundation

public enum Token {
    case lparen(Int)
    case rparen(Int)
    case colon(Int)
    case assign(Int)
    case word(String, Int, Int)
    case int(String, Int, Int)
    case cmp(String, Int)
    case and(Int)
    case comment(String, Int, Int)
    case or(Int)
}
