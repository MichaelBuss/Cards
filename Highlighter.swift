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
    
    static func getRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> NSColor {
        return NSColor.init(red: red/256.0, green: green/256.0, blue: blue/256.0, alpha: 1)
    }
    
    static let solarized = [
        "base03" : getRGB(red: 0, green: 43, blue: 54),
        "base02" : getRGB(red: 7, green: 54, blue: 66),
        "base01" : getRGB(red: 88, green: 110, blue: 117),
        "base00" : getRGB(red: 101, green: 123, blue: 131),
        "base0"  : getRGB(red: 131, green: 148, blue: 150),
        "base1"  : getRGB(red: 147, green: 161, blue: 161),
        "base2"  : getRGB(red: 238, green: 232, blue: 213),
        "base3"  : getRGB(red: 253, green: 246, blue: 227),
        "yellow" : getRGB(red: 181, green: 137, blue: 0),
        "orange" : getRGB(red: 203, green: 75, blue: 22),
        "red"    : getRGB(red: 220, green: 50, blue: 47),
        "magenta": getRGB(red: 211, green: 54, blue: 130),
        "violet" : getRGB(red: 108, green: 113, blue: 196),
        "blue"   : getRGB(red: 38, green: 139, blue: 210),
        "cyan"   : getRGB(red: 42, green: 161, blue: 152),
        "green"  : getRGB(red: 133, green: 153, blue: 0)
    ]
    
    static let ayu = [
        "error": getRGB(red: 255,	green:51,	blue:51),
        "line_hg": getRGB(red: 242,	green:242,	blue:242),
        "gutterFg": getRGB(red: 217,	green:216,	blue:215),
        "selection": getRGB(red: 240,	green:238,	blue:228),
        "stack_guide": getRGB(red: 222,	green:221,	blue:220),
        "active_guide": getRGB(red: 179,	green:178,	blue:177),
        "tag": getRGB(red: 65,    green:166,	blue:217),
        "func": getRGB(red: 242,	green:151,	blue:24),
        "regexp": getRGB(red: 77,    green:191,	blue:153),
        "string": getRGB(red: 134,	green:179,	blue:0),
        "comment": getRGB(red: 171,	green:176,	blue:182),
        "sup_var": getRGB(red: 240,	green:113,	blue:120),
        "es_spec": getRGB(red: 204,	green:163,	blue:122),
        "keyword": getRGB(red: 242,	green:89,	blue:12),
        "operator": getRGB(red: 231,	green:197,	blue:71),
        "constant": getRGB(red: 163,	green:122,	blue:204)
    ]
    
    static let ident_def = ["gem", "ny funktion"]
    static let keywords = ["gentag", "hvis", "ellers", "funktion"]
    static let funcs = ["frem", "tilbage", "drej", "højttaler", "brems", "motor a", "motor b"]
    static let color_consts = [
        "rød": (Highlighter.ayu["keyword"], NSColor.white),
        "grøn": (Highlighter.ayu["string"], NSColor.white),
        "gul": (Highlighter.ayu["func"], NSColor.white),
        "blå": (Highlighter.ayu["tag"], NSColor.white),
        "sort": (NSColor.init(red: 0.5, green: 0.5, blue:0.5, alpha: 1), NSColor.white),
        "hvid": (NSColor.white, NSColor.init(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))
    ]
    static let consts = ["left", "right", "til væg", "til kontakt", "farve"]
    static let units = ["cm", "mm", "grader"]
    
    static let colors = ["ident_def": Highlighter.ayu["keyword"],
                         "keyword":   Highlighter.ayu["keyword"],
                         "funcs":     Highlighter.ayu["func"],
                         "int_lit":   Highlighter.ayu["tag"],
                         "consts":    Highlighter.ayu["string"],
                         "idents":    Highlighter.ayu["func"]
    ]
    
    private func color(col: String) -> NSColor {
        return Highlighter.colors[col]!!
    }
    
    public func getHighlightedString() -> NSMutableAttributedString {
        //let out = NSMutableAttributedString(string: str)
        
        //var idents = [String]()
        
        while i<len {
            switch tokens[i] {
            case .word(let w, let idx, var l):
                var col = NSColor.black
                var background = NSColor.white
                if i<len-1 && Highlighter.ident_def.contains(w) {
                    col = color(col: "ident_def")
                    if i<len-2 {
                        switch tokens[i+2] {
                        case .word(let ident, _, _):
                            print(ident)
                            idents.append(ident)
                        default:
                            print("Invalid identifier found")
                        }
                    }
                    l += 1
                } else if i<len-1 && Highlighter.keywords.contains(w) {
                    col = color(col: "keyword")
                    l += 1
                } else if i<len-1 && Highlighter.funcs.contains(w) {
                    col = color(col: "funcs")
                    l += 1
                } else if Highlighter.consts.contains(w) {
                    col = color(col: "consts")
                } else if let (bc, fc) = Highlighter.color_consts[w] {
                    col = fc
                    background = bc!
                    //l -= 1
                } else if idents.contains(w) {
                    col = color(col: "idents")
                }
                
                ats.addAttributes([NSForegroundColorAttributeName: col, NSBackgroundColorAttributeName: background], range: NSRange(location: idx, length: l))
            case .int(_, let idx, var l):
                if i<len-1 {
                    switch tokens[i+1] {
                    case .word(let w, _, let len):
                        l += len + 1
                        i += 1
                    default:
                        print("Invalid identifier found")
                    }
                }
                ats.addAttributes([NSForegroundColorAttributeName: color(col: "int_lit")], range: NSRange(location: idx, length: l))
            default:
                print("nothing")
            }
            i+=1
        }
        
        return ats
    }
}
