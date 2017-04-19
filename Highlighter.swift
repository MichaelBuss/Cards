//
//  Highlighter.swift
//  Cards
//
//  Created by Anton Eskildsen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Foundation
import AppKit

public class Highlighter {
    let tokens: [Token]
    let len: Int
    let str: String
    var i: Int
    var idents: [String]
    var ats: NSMutableAttributedString
    
    public init(str: String, ats: NSMutableAttributedString) {
        self.ats = ats
        let lexer = Lexer(str: str)
        idents = [String]()
        self.str = str
        do {
            tokens = try lexer.lex()
            len = tokens.count
        } catch {
            tokens = [Token]()
            len = 0
            print("Lexer error")
        }
        i = 0
    }
    
    static let ident_def = ["Gem", "Ny Funktion"]
    static let keywords = ["Gentag", "Hvis", "Ellers", "Funktion"]
    static let funcs = ["Frem", "Tilbage", "Drej", "Højttaler", "Brems", "Motor A", "Motor B"]
    static let consts = ["rød", "grøn", "gul", "blå", "sort", "hvid", "Left", "Right"]
    
    static let colors = ["ident_def": NSColor.red,
                         "keyword":   NSColor.init(red: 0.164, green: 0.629, blue: 0.594, alpha: 1),
                         "funcs":     NSColor.brown,
                         "int_lit":   NSColor.purple,
                         "consts":    NSColor.init(red: 0.52, green: 0.598, blue: 0, alpha: 1),
                         "idents":    NSColor.blue]
    
    private func color(col: String) -> NSColor {
        return Highlighter.colors[col]!
    }
    
    public func getHighlightedString() -> NSMutableAttributedString {
        //let out = NSMutableAttributedString(string: str)
        
        //var idents = [String]()
        
        while i<len {
            switch tokens[i] {
            case .word(let w, let idx, var l):
                var col = NSColor.black
                if i<len-1 {
                    if Highlighter.ident_def.contains(w) {
                    col = color(col: "ident_def")
                    if i<len-2 {
                        switch tokens[i+2] {
                        case .word(let ident, _, _):
                            print(ident)
                            idents.append(ident)
                        default:
                            print("Invalid identifier found")
                        }
                        l += 1
                    }
                    } else if Highlighter.keywords.contains(w) {
                        col = color(col: "keyword")
                        l += 1
                    } else if Highlighter.funcs.contains(w) {
                        col = color(col: "funcs")
                        l += 1
                    }
                } else if Highlighter.consts.contains(w) {
                    col = color(col: "consts")
                } else if idents.contains(w) {
                    col = color(col: "idents")
                }
                
                ats.addAttributes([NSForegroundColorAttributeName: col], range: NSRange(location: idx, length: l))
            case .int(_, let idx, let l):
                ats.addAttributes([NSForegroundColorAttributeName: color(col: "int_lit")], range: NSRange(location: idx, length: l))
            default:
                print("nothing")
            }
            i+=1
        }
        
        return ats
    }
}
