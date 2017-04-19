//: Playground - noun: a place where people can play

import Cocoa



import PlaygroundSupport

public enum Token {
    case lparen(Int)
    case rparen(Int)
    case colon(Int)
    case assign(Int)
    case word(String, Int, Int)
    case int(String, Int, Int)
    case cmp(String, Int)
    case and(Int)
    case or(Int)
}

public class Lexer {
    
    /*public enum Token {
        case lparen(Int)
        case rparen(Int)
        case colon(Int)
        case assign(Int)
        case word(String, Int)
        case int(Int, Int)
        case cmp(String, Int)
        case and(Int)
        case or(Int)
    }*/
    
    var cur_idx = 0
    var out = [Token]()
    var chars: [Character]
    let end: Int
    
    public init(str: String) {
        chars = Array(str.characters)
        end = chars.count
    }
    
    public enum LexerError : Error {
        case UnexpectedInput(String)
        case UnknownInput(String)
    }
    
    
    private func isAlpha(char: Character) -> Bool {
        return Array("ABCDEFGHIJKLMNOPQRSTUVÆØÅXYZabcdefghijklmnopqrstuvwxyzæøå".characters).contains(char)
    }
    
    private func isSpace(char: Character) -> Bool {
        return char == " "
    }
    
    private func isDigit(char: Character) -> Bool {
        return Array("0123456789".characters).contains(char)
    }
    
    private func isWhiteSpace(char: Character) -> Bool {
        return Array(" \n\t".characters).contains(char)
    }
    
    private func expectNext(char: Character, input: [Character], idx: Int) -> Bool {
        return idx < input.count && input[idx] == char
    }
    
    private func eatWhiteSpace() {
        while cur_idx < end && isWhiteSpace(char: chars[cur_idx]) { cur_idx+=1 }
    }
    
    private func doubleOrSingleCmp(first: Character, last: Character) {
        if cur_idx+1 < end && chars[cur_idx+1] == last {
            out.append(Token.cmp(String([first, last]), cur_idx))
            cur_idx += 2
        } else {
            out.append(Token.cmp(String(first), cur_idx))
            cur_idx += 1
        }
    }
    
    private func stripTrailingSpaces(idx: Int) -> Int {
        var out = idx
        while isWhiteSpace(char: chars[out]) { out -= 1 }
        return out
    }
    
    
    public func lex() throws -> [Token] {
        eatWhiteSpace()
        while cur_idx < end {
            switch chars[cur_idx] {
            case "(":
                out.append(Token.lparen(cur_idx))
                cur_idx += 1
            case ")":
                out.append(Token.rparen(cur_idx))
                cur_idx += 1
            case ":":
                out.append(Token.colon(cur_idx))
                cur_idx += 1
            case "=":
                doubleOrSingleCmp(first: "=", last: "=")
            case "<":
                doubleOrSingleCmp(first: "<", last: "=")
            case ">":
                doubleOrSingleCmp(first: ">", last: "=")
            case "|":
                if cur_idx+1 < chars.count && chars[cur_idx+1] == "|" {
                    out.append(Token.or(cur_idx))
                    cur_idx += 2
                } else {
                    let actual = cur_idx+1 < chars.count ? String(chars[cur_idx+1]) : "EOF"
                    throw LexerError.UnexpectedInput("Expected | but got " + actual)
                }
            case "&":
                if cur_idx+1 < chars.count && chars[cur_idx+1] == "&" {
                    out.append(Token.and(cur_idx))
                    cur_idx += 2
                } else {
                    let actual = cur_idx+1 < chars.count ? String(chars[cur_idx+1]) : "EOF"
                    throw LexerError.UnexpectedInput("Expected & but got " + actual)
                }
            case _ where isDigit(char: chars[cur_idx]):
                let start_idx = cur_idx
                while cur_idx < end && isDigit(char: chars[cur_idx]) { cur_idx += 1 }
                out.append(Token.int(String(chars[start_idx..<cur_idx]), start_idx, cur_idx-start_idx))
                
            case _ where isAlpha(char: chars[cur_idx]):
                let start_idx = cur_idx
                while cur_idx < end &&
                    (isAlpha(char: chars[cur_idx]) || isSpace(char: chars[cur_idx]) ) { cur_idx += 1 }
                let end_idx = stripTrailingSpaces(idx: cur_idx-1)
                out.append(Token.word(String(chars[start_idx...end_idx]), start_idx, cur_idx-start_idx))
                
            default:
                throw LexerError.UnknownInput("Lexer didn't recognize input character \(chars[cur_idx]) at \(cur_idx)")
            }
            eatWhiteSpace()
        }
        return out
    }
}

public class Highlighter {
    let tokens: [Token]
    let len: Int
    let str: String
    var i: Int
    var idents: [String]
    
    public init(str: String) {
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
        let out = NSMutableAttributedString(string: str)
        
        //var idents = [String]()
        
        while i<len {
            switch tokens[i] {
            case .word(let w, let idx, var l):
                var col = NSColor.black
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
                    }
                } else if Highlighter.keywords.contains(w) {
                    col = color(col: "keyword")
                    l += 1
                } else if Highlighter.funcs.contains(w) {
                    col = color(col: "funcs")
                    l += 1
                } else if Highlighter.consts.contains(w) {
                    col = color(col: "consts")
                } else if idents.contains(w) {
                    col = color(col: "idents")
                }
                
                out.addAttributes([NSForegroundColorAttributeName: col], range: NSRange(location: idx, length: l))
            case .int(_, let idx, let l):
                out.addAttributes([NSForegroundColorAttributeName: color(col: "int_lit")], range: NSRange(location: idx, length: l))
            default:
                print("nothing")
            }
            i+=1
        }
        
        return out
    }
}

var pg = ""
do {
    let path = Bundle.main.path(forResource: "program", ofType: "txt")
    pg = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
} catch {
    let pg = ""
}

do {
    let lexer = Lexer(str: "fre")
    let lexed = try lexer.lex()
    for token in lexed {
        print(token)
    }
} catch {
    print("not good")
}


func highlightAttributedString(string: String, syntaxInfo: [(String, Int, Int)], colors:[String: NSColor]) -> NSMutableAttributedString {
    let out = NSMutableAttributedString(string: string)
    for (color, idx, offset) in syntaxInfo {
        out.addAttributes([NSForegroundColorAttributeName: colors[color]], range: NSRange(location: idx, length: offset))
    }
    return out
}


func isIdent(char: Character) -> Bool {
    return Array("ABCDEFGHIJKLMNOPQRSTUVÆØÅ wXYZabcdefghijklmnopqrstuvwxyzæøå".characters).contains(char)
}

func isAlpha(char: Character) -> Bool {
    return Array("ABCDEFGHIJKLMNOPQRSTUVÆØÅXYZabcdefghijklmnopqrstuvwxyzæøå".characters).contains(char)
}

func isDigit(char: Character) -> Bool {
    return Array("0123456789".characters).contains(char)
}

func isWhiteSpace(char: Character) -> Bool {
    return Array(" \n\t".characters).contains(char)
}

func matchIdent(input: [Character], from: Int) -> Int {
    var i = 0
    while isAlpha(char: input[from+i]) {i+=1}
    return i
}

func matchClass(input: [Character], from: Int, charClass: (Character) -> Bool) -> Int {
    var i = 0
    while from+i < input.count && charClass(input[from+i]) {i+=1}
    return i
}

func idxToInt(string: String, idx: String.Index) -> Int {
    return string.distance(from: string.startIndex, to: idx)
}

/*func generateSyntaxInfo(string: String) -> [(String, Int, Int)] {
    var out = [(String, Int, Int)]()
    var cur_idx = string.startIndex
    while cur_idx != string.endIndex {
        var offset = matchClass(string: string, from: cur_idx, charClass: isWhiteSpace)
        cur_idx = string.index(cur_idx, offsetBy: offset)
        offset = matchClass(string: string, from: cur_idx, charClass: isAlpha)
        var end_idx = string.index(cur_idx, offsetBy: offset)
        if string[end_idx] == ":" {
            end_idx = string.index(end_idx, offsetBy: 1)
            out.append(("key", idxToInt(string: string, idx: cur_idx), idxToInt(string: string, idx: cur_idx)))
        }
        print(cur_idx)
        cur_idx = end_idx
    }
    return out
}*/

let ident_def = ["Gem:", "Ny Funktion:"]
let keywords = ["Gem:", "Gentag:", "Hvis:", "Ellers:", "Ny Funktion:", "Funktion:"]
let built_in = ["Frem:", "Tilbage:", "Drej:", "Højttaler:", "Brems:"]

func generateSyntaxInfo2(string: String) -> [(String, Int, Int)] {
    var custom_idents = [String]()
    var chars = Array(string.characters)
    var cur_i = 0
    var out = [(String, Int, Int)]()
    while cur_i < chars.count {
        cur_i += matchClass(input: chars, from: cur_i, charClass: isWhiteSpace)
        var offset = 0
        if isDigit(char: chars[cur_i]) {
            offset = matchClass(input: chars, from: cur_i, charClass: isDigit)
            print(String(chars[cur_i...(cur_i+offset)]))
            out.append(("num_literal", cur_i, offset))
        } else {
            offset = matchClass(input: chars, from: cur_i, charClass: isIdent)
            let ident = String(chars[cur_i...(cur_i+offset)])
            if chars[cur_i+offset] == ":" {
                if ident_def.contains(ident) {
                    out.append(("key", cur_i, offset+1))
                    cur_i += offset+1
                    let ident_offset = matchClass(input: chars, from: cur_i, charClass: isIdent)
                    custom_idents.append(String(chars[cur_i...(cur_i+offset)]))
                    out.append(("ident", cur_i, offset+1))
                } else if keywords.contains(ident) {
                    out.append(("key", cur_i, offset+1))
                } else if built_in.contains(ident) {
                    out.append(("built_in", cur_i, offset+1))
                }
            
            } else if custom_idents.contains(ident) {
                out.append(("ident", cur_i, offset))
            }
        }
        cur_i += offset+1
    }
    return out
}

let ts = "Ny Funktion: Væg og bak\n Hejsa:"
/*var pg = ""
do {
    let path = Bundle.main.path(forResource: "program", ofType: "txt")
    pg = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
} catch {
    let pg = ""
}
let t = generateSyntaxInfo2(string: pg)*/


class CustomView: NSView {
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        /*let str = "Hello, playground"
        
        let si = [("key", 0, 2), ("key", 5, 5)]
        let cs = ["key": NSColor.red]
        let astr = highlightAttributedString(string: str, syntaxInfo: si, colors: cs)*/
        
        let ts = "Ny Funktion: Væg og bak\n Hejsa:"
        
        var pg = ""
        do {
            let path = Bundle.main.path(forResource: "program", ofType: "txt")
            pg = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            let pg = ""
        }
        
        let h = Highlighter(str: pg)
        let astr = h.getHighlightedString()
        /*let t = generateSyntaxInfo2(string: pg)
        
        let cs = ["key": NSColor.red,
                  "built_in": NSColor.brown,
                  "num_literal": NSColor.gray,
                  "ident": NSColor.green]
        let astr = highlightAttributedString(string: pg, syntaxInfo: t, colors: cs)
        */
        astr.draw(in: rect)
        
        //
    }
}

let containerView = CustomView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

PlaygroundPage.current.liveView = containerView
