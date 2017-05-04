//
//  Lexer.swift
//  Cards
//
//  Created by Anton Eskildsen on 16/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Foundation

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
        return Array(" \n\t\u{00A0}".characters).contains(char)
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
                out.append(Token.word(String(chars[start_idx...end_idx]).lowercased(), start_idx, end_idx-start_idx+1))
                
            default:
                print("Lexer didn't recognize input character \(chars[cur_idx]) at \(cur_idx)")
                throw LexerError.UnknownInput("Lexer didn't recognize input character \(chars[cur_idx]) at \(cur_idx)")
            }
            eatWhiteSpace()
        }
        return out
    }
}
