//
// Created by Anton Eskildsen on 02/05/2017.
// Copyright (c) 2017 NoobLabs. All rights reserved.
//

import Foundation
import AppKit

class SmartReplacer {
    let ats: NSMutableAttributedString
    let sel: NSTextView

    static let replacements = [
            "eller": (nil, "||"),
            "og": (nil, "&&"),
            "større": (["end"], ">"),
            "mindre": (["end"], "<"),
            "lig": (["med"], "=="),
            ">": (["||", "=="], ">="),
            "<": (["||", "=="], ">=")
    ]

    public init(ats: NSMutableAttributedString, sel: NSTextView) {
        self.ats = ats
        self.sel = sel
    }

    public func replace() -> Int {
        var posDelta = 0
        var sTokens = ats.string.components(separatedBy: " ")
        var pos = 0
        for (i, t) in sTokens.enumerated() {
            var tLen = t.characters.count
            if let (next, rep) = SmartReplacer.replacements[t] {
                var repLen = rep.characters.count
                
                if next != nil {
                    var j = 0
                    var offset = 0
                    var shouldContine = false
                    while j < next!.count && i+j+1 < sTokens.count {
                        if sTokens[i+j+1] != next![j] { shouldContine=true; break }
                        offset += sTokens[i+j+1].characters.count + 1
                        j+=1
                        
                    }
                    if shouldContine {
                        pos += tLen+1
                        continue
                    }
                    tLen += offset
                }
                posDelta += tLen - repLen
                sTokens[i] = rep
                var r = sel.selectedRange()
                if r.location >= pos+repLen && r.location <= pos+tLen {
                    r.location -= (tLen-repLen)-1
                    sel.setSelectedRange(r)
                }
                
                ats.replaceCharacters(in: NSMakeRange(pos, tLen), with: rep)
                pos += repLen + 1
            } else {
                pos += tLen + 1
            }
        }
        return posDelta
    }
}
