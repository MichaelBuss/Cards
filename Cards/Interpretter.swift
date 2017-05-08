//
//  Interpretter.swift
//  Cards
//
//  Created by Magnus Meng on 29/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

struct CompileSettings {
    var rotationmm: String
    var rotationdeg: String
}

class Interpretter: NSObject {
    
    var errors: [String]
    
    public static func compile(code: String, settings: CompileSettings) -> (String, [String]) {
        
        do {
            let path = Bundle.main.path(forResource: "header", ofType: "py")
            var header = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
            header = header.replacingOccurrences(of: "{rotationmm}", with: settings.rotationmm)
            header = header.replacingOccurrences(of: "{rotationdeg}", with: settings.rotationdeg)
            
            let interpretter = Interpretter()
            let code = header + interpretter.convertToPython(code: interpretter.removeComments(code: code))
            let errors = interpretter.errors
            return (code, errors)
        } catch _ {
            print("Could not find header file")
        }
        return ("", Array())
    }
    
    
    
    
    public override init() {
        errors = ["test"]
    }
    
    enum CustomError : Error {
        case BadFormat(String)
    }
    
    func removeComments(code: String) -> String {
        var res = ""
        
        let codeArr = code.components(separatedBy: "\n")
        
        for line in codeArr {
            var splitLine = line.components(separatedBy: "//")
            res += splitLine[0] + "\n"
        }
        
        return res
    }
    
    //Indents lines of code by one tab
    private func indent(code: String) -> String {
        let lines = code.characters.split(separator: "\n")
        var res = ""
        for line in lines {
            res += "\t" + String(line) + "\n"
        }
        return res
    }
    
    //Takes a string of pseudocode starting with a '(' and finds the matching ')' to return the group that the '(' started and the remaining code.
    private func extractGroup(codeSnippet: String) throws -> [String]  {
        var rest = codeSnippet
        var group = ""
        var count = 0
        
        //Check that first character is '(' and that string is well-formed.
        if rest.characters.first != "(" {
            throw CustomError.BadFormat("Group didn't start with '('")
        }
        else {
            rest = String(rest.characters.dropFirst())
            count += 1
        }
        
        for char in codeSnippet.characters.dropFirst() {
            if char == "(" {
                count += 1
            }
            if char == ")" {
                count -= 1
            }
            
            if count == 0 {
                return [group, String(rest.characters.dropFirst())]
            }
            
            group += String(rest.characters.prefix(1))
            rest = String(rest.characters.dropFirst())
        }
        
        throw CustomError.BadFormat("No matching ')'")
    }
    
    //Splits a string at the first occurence of a character. Returns a tuple (before separator, after separator)
    private func splitAtFirstOccurence(str: String, separator: Character) -> [String] {
        var spl = str.characters.split(separator: separator)
        let start = String(spl[0])
        var rest = ""
        for elm in spl.dropFirst() {
            rest += String(separator)+String(elm)
        }
        if !(rest.isEmpty) {
            rest.remove(at: rest.startIndex)
        }
        
        return [start, rest]
    }
    
    //Convert turn command argument to Python.
    private func turnCommand(argument: String) -> String {
        if argument.contains("grad") {
            let dist = splitAtFirstOccurence(str: argument, separator: " ")[0]
            if argument.contains("venstre") {
                return "\nturn(unit=\"degrees\", amount="+dist+", speed=50, direction=-1)\n"
            }
            else {
                return "\nturn(unit=\"degrees\", amount="+dist+", speed=50, direction=1)\n"
            }
        }
        
        print("An error occured. Argument "+argument+" unknown.")
        return argument
    }
    
    //Convert if argument to Python
    private func ifArgument(condition: String) -> String {
        var modifier = ""
        if condition.contains("||") {
            let conditionArr = condition.components(separatedBy: "||")
            var res = ""
            for index in 0...conditionArr.count-1 {
                res += ifArgument(condition: conditionArr[index])
                if index<conditionArr.count-1 {
                    res += " or "
                }
            }
            return res
        }

        if condition.contains("ikke") {
            modifier = "not "
        }
        
        if condition.contains("farve") { //Used to be: isColor(color=\"red\") Dosn't work with more than one in Hvis:
            if condition.contains("rød") {
                return modifier+"cs.value() == 5"
            }
            if condition.contains("blå") {
                return modifier+"cs.value() == 2"
            }
            if condition.contains("grøn") {
                return modifier+"cs.value() == 3"
            }
            if condition.contains("sort") {
                return modifier+"cs.value() == 1"
            }
            if condition.contains("hvid") {
                return modifier+"cs.value() == 6"
            }
            if condition.contains("gul") {
                return modifier+"cs.value() == 4"
            }
            if condition.contains("brun") {
                return modifier+"cs.value() == 7"
            }
            //Tilføj selv flere farver her
        }
        if condition.contains("kontakt") {
            return modifier+"ts.value()"
        }
        
        if condition.contains("afstand") { //Mangler implementering
            let chars = Array(condition.characters)
            var i = 0
            while (i < chars.count && !isDigit(char: chars[i])) { i+=1 }
            let s = i
            while (i < chars.count && isDigit(char: chars[i])) {i+=1}
    
            let n = String(chars[s...i])
            let number = Int(n)
            
            var ad = ""
            if (condition.contains("<")) {
                ad = "us.value()/10 < " + n
            } else if (condition.contains(">")) {
                ad = "us.value()/10 > " + n
            }
            return modifier+ad
        }
        
        print("An error occured. Condition "+condition+" unknown.")
        errors.append("An error occured. Condition "+condition+" unknown.")
        return condition
    }
    
    private func isDigit(char: Character) -> Bool {
        return Array("0123456789".characters).contains(char)
    }
    
    //Convert for/while argument to Python
    private func forStatement(condition: String) -> String {
        let trimCon = condition.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimCon.contains("gang") {
            let times = splitAtFirstOccurence(str: trimCon, separator: " ")[0]
            return "\nfor i in range("+times+"):\n"
        }
        if trimCon.contains("kontakt") {
            return "while not ts.value():\n"
        }
        
        print("An error occured. Condition "+condition+" unknown.")
        errors.append("An error occured. Condition "+condition+" unknown.")
        return condition
    }
    
    private func soundCommand(argument: String) -> String {
        let arg = argument.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\nSound.speak(\"" + arg + "\").wait()\n"
    }
    
    private func stopCommand() -> String {
        return "\nbrake()\n"
    }
    
    private func functionCommand(name: String) -> String {
        let trimName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\ndef "+trimName+"():\n"
    }
    
    private func functionCall(name: String) -> String {
        let trimName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\n"+trimName+"()\n"
    }
    
    private func backCommand(argument: String) -> String {
        if argument == "forever" {
            return "\ndrive(unit=\"forever\", direction=-1)\n"
        }
        
        if argument.contains("cm") {
            let dist = splitAtFirstOccurence(str: argument, separator: " ")[0]
            return "\ndrive(unit=\"cm\", amount="+dist+", speed=50, direction=-1)\n"
        }
        if argument.contains("sekund") {
            let time = splitAtFirstOccurence(str: argument, separator: " ")[0]
            return "\ndrive(unit=\"seconds\", amount="+time+", speed=50, direction=-1)\n"
        }
        if argument.contains("grad") {
            let dist = splitAtFirstOccurence(str: argument, separator: " ")[0]
            return "\ndrive(unit=\"degrees\", amount="+dist+", speed=50, direction=-1)\n"
        }
        
        if argument.trimmingCharacters(in: .whitespacesAndNewlines) == "til kontakt" {
            return "\nwhile not ts.value():\n"+indent(code: "drive(unit=\"forever\", direction=-1)")+"brake()\n"
        }
        print("An error occured. Argument "+argument+" unknown.")
        errors.append("An error occured. Argument "+argument+" unknown.")
        return argument
    }
    
    func huskCommand(argument: String) ->  String {
        let variable = splitAtFirstOccurence(str: argument, separator: "=")[0].trimmingCharacters(in: .whitespacesAndNewlines)
        
        return variable + "=myDirtyDirtyConstant"
    }
    
    private func forwardCommand(argument: String) -> String {
        if argument == "forever" {
            return "\ndrive(unit=\"forever\")\n"
        }
        
        if argument.contains("cm") {
            let dist = splitAtFirstOccurence(str: argument, separator: " ")[0]
            return "\ndrive(unit=\"cm\", amount="+dist+", speed=50, direction=1)\n"
        }
        if argument.contains("sekund") {
            let time = splitAtFirstOccurence(str: argument, separator: " ")[0]
            return "\ndrive(unit=\"seconds\", amount="+time+", speed=50, direction=1)\n"
        }
        if argument.contains("grad") {
            let dist = splitAtFirstOccurence(str: argument, separator: " ")[0]
            return "\ndrive(unit=\"degrees\", amount="+dist+", speed=50, direction=1)\n"
        }
        
        if argument.trimmingCharacters(in: .whitespacesAndNewlines) == "til kontakt" {
            return "\nwhile not ts.value():\n"+indent(code: "\ndrive(unit=\"forever\")")+"brake()\n"
        }
        print("An error occured. Argument "+argument+" unknown.")
        errors.append("An error occured. Argument "+argument+" unknown.")
        return argument
    }
    
    private func motorACommand(argument: String) -> String {
        if argument.contains("rotation") {
            let dist = splitAtFirstOccurence(str: argument, separator: " ")[0]
            if argument.contains("frem") {
                return "\nsingleMotor(amount="+dist+", direction=1)\n"
            }
            else {
                return "\nsingleMotor(amount="+dist+", direction=-1)\n"
            }
        }
        
        print("An error occured. Argument "+argument+" unknown.")
        errors.append("An error occured. Argument "+argument+" unknown.")
        return argument
    }
    
    
    //Converts pseudocode to Python
    private func convertToPython(code: String) -> String {
        var keyword :  String
        var rest    :  String
        var split   : [String]
        
        //Removing whitespace/newlines before and after code
        var trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var mainBody = ""
        var functionHeader = ""
        
        while !(trimmedCode.isEmpty) {
            if splitAtFirstOccurence(str: trimmedCode, separator: "\n")[0].contains(":") {
                split = splitAtFirstOccurence(str: trimmedCode, separator: ":")
                
                keyword = split[0]
                rest = split[1]
                
                switch keyword {
                case "hvis":
                    //Splitting string at '(' into the condition and the remaining code
                    split = splitAtFirstOccurence(str: rest, separator: "(")
                    
                    //Adding the if-statemnt corresponding to the condition
                    mainBody += "\nif " + ifArgument(condition: split[0]).trimmingCharacters(in: .whitespacesAndNewlines) + ":\n"
                    
                    //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
                    do {
                        try split = extractGroup(codeSnippet: "("+split[1])
                    } catch {
                        print("Bad formatting")
                        errors.append("Bad formatting")
                    }
                    
                    //The code that the if-statement decides is converted to Python recursively and added
                    mainBody += indent(code: convertToPython(code: split[0]))
                    
                    //Next round of the loop will use the remaining code
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "ellers hvis":
                    //Splitting string at '(' into the condition and the remaining code
                    split = splitAtFirstOccurence(str: rest, separator: "(")
                    
                    //Adding the if-statemnt corresponding to the condition
                    mainBody += "\nelif " + ifArgument(condition: split[0]).trimmingCharacters(in: .whitespacesAndNewlines) + ":\n"
                    
                    //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
                    do {
                        try split = extractGroup(codeSnippet: "("+split[1])
                    } catch {
                        print("Bad formatting")
                        errors.append("Bad formatting")
                    }
                    
                    //The code that the if-statement decides is converted to Python recursively and added
                    mainBody += indent(code: convertToPython(code: split[0]))
                    
                    //Next round of the loop will use the remaining code
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "ellers":
                    //Splitting string at '(' into the condition and the remaining code
                    split = splitAtFirstOccurence(str: rest, separator: "(")
                    
                    //Adding the if-statemnt corresponding to the condition
                    mainBody += "\nelse:\n"
                    
                    //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
                    do {
                        try split = extractGroup(codeSnippet: "("+split[1])
                    } catch {
                        print("Bad formatting")
                        errors.append("Bad formatting")
                    }
                    
                    //The code that the if-statement decides is converted to Python recursively and added
                    mainBody += indent(code: convertToPython(code: split[0]))
                    
                    //Next round of the loop will use the remaining code
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "gentag":
                    //Splitting string at '(' into the condition and the remaining code
                    split = splitAtFirstOccurence(str: rest, separator: "(")
                    
                    //Adding the for-statemnt corresponding to the condition
                    mainBody += forStatement(condition: split[0])
                    
                    //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
                    do {
                        try split = extractGroup(codeSnippet: "("+split[1])
                    } catch {
                        print("Bad formatting")
                        errors.append("Bad formatting")
                    }
                    
                    //The code that the if-statement decides is converted to Python recursively and added
                    mainBody += indent(code: convertToPython(code: split[0]))
                    
                    //Next round of the loop will use the remaining code
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    
                case "højtaler":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += soundCommand(argument: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "drej":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += turnCommand(argument: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    
                case "tilbage":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += backCommand(argument: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "frem":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += forwardCommand(argument: split[0])
                    
                    //if (split.count > 2) {
                        trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    //}
                    
                case "husk":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += huskCommand(argument: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "tilbage":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += backCommand(argument: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "motor a":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += motorACommand(argument: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "funktion":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += functionCall(name: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "ny funktion":
                    //Splitting string at '(' into the condition and the remaining code
                    split = splitAtFirstOccurence(str: rest, separator: "(")
                    
                    //Adding the if-statemnt corresponding to the condition
                    functionHeader += functionCommand(name: split[0])
                    
                    //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
                    do {
                        try split = extractGroup(codeSnippet: "("+split[1])
                    } catch {
                        print("Bad formatting")
                        errors.append("Bad formatting")
                    }
                    
                    //The code that the if-statement decides is converted to Python recursively and added
                    functionHeader += indent(code: convertToPython(code: split[0]))
                    
                    //Next round of the loop will use the remaining code
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                default:
                    return "Unhandled case:" + keyword
                }
            }
            else {
                split = splitAtFirstOccurence(str: trimmedCode, separator: "\n")
                keyword = split[0].trimmingCharacters(in: .whitespacesAndNewlines)
                
                switch keyword {
                case "brems":
                    mainBody += stopCommand()
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    
                case "frem":
                    //Splitting string at newline
                    mainBody += forwardCommand(argument: "forever")
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "tilbage":
                    //Splitting string at newline
                    mainBody += backCommand(argument: "forever")
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                default:
                    return "Unhandled case:" + keyword
                }
            }
        }
        return functionHeader + "\n" + mainBody
    }
    
}


//
//
// pseudoToPython.playground
// Cards
//
// Created by Peter Michael Reichstein Rasmussen on 30/03/2017
// Copyright © 2017 NoobLabs. All rights reserved.
//



/*

//Test
var code = "frem: 10 cm\nhøjtaler: Hello\n\nNy funktion: toWall (\n\tfrem:til kontakt\n \ttilbage: 5 cm\n)\n\nFunktion:toWall\nDrej: 90 grader til højre\n frem: til kontakt\n\nGentag: 3 gange(\n\tDrej: 40 grader til højre\n\thøjtaler: Right\n\tDrej: 10 grader til venstre\n\thøjtaler: Left\n)\n\nFrem: til kontakt\nHvis: Farve er rød (\n\tMotorA: 1 rotation frem\n)\nEllers hvis: farve er sort(\n\tMotorA: 3 rotationer tilbage\n)\nEllers: (\n\tmotorA: 4 rotationer frem\n)\n\ntilbage: 5 cm\nDrej: 90 grader til venstre\n\nGentag: til kontakt (\n\tHvis: Farve er rød (\n\t\tBrems\n\t)\n\tEllers: (\n\t\tFrem\n\t)\n)\n\nTilbage: 5 cm\nDrej: 40 grader til højre\nTilbage: 1 sekund\n\nFrem: til kontakt\n Tilbage: 5 cm\nDrej: 90 grader til venstre"


var interpretter = Interpretter()
let pythonCode = interpretter.compile(code)


print("#### Code ####")
print(code)

print("#### Errors ####")

print("\n#### Compiles to ####")
print(pythonCode)



*/


