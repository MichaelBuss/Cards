// 
//
// pseudoToPython.playground
// Cards
//
// Created by Peter Michael Reichstein Rasmussen on 30/03/2017
// Copyright © 2017 NoobLabs. All rights reserved.
//


import UIKit

enum CustomError : Error {
    case BadFormat(String)
}


//Indents lines of code by one tab
func indent(code: String) -> String {
    let lines = code.characters.split(separator: "\n")
    var res = ""
    for line in lines {
        res += "\t" + String(line) + "\n"
    }
    return res
}

//Takes a string of pseudocode starting with a '(' and finds the matching ')' to return the group that the '(' started and the remaining code.
func extractGroup(codeSnippet: String) throws -> [String]  {
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
func splitAtFirstOccurence(str: String, separator: Character) -> [String] {
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
func turnArgument(argument: String) -> String {
    //To be implemented
    return argument
}

//Convert if argument to Python
func ifArgument(condition: String) -> String {
    //To be implemented
    return condition
}

//Convert for/while argument to Python
func forStatement(condition: String) -> String {
    //To be implemented
    return condition
}

//Convert sound command to Python
func forStatement(condition: String) -> String {
    //To be implemented
    return condition
}


//Converts pseudocode to Python
func convertToPython(code: String) -> String {
    var keyword :  String
    var rest    :  String
    var split   : [String]
    
    //Removing whitespace/newlines before and after code
    var trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    var res = ""
    
    
    while !(trimmedCode.isEmpty) {
        //Finding first occurence of ':' to separate code into the first occuring keyword and the remainder
        split = splitAtFirstOccurence(str: trimmedCode, separator: ":")
        
        keyword = split[0]
        rest = split[1]
        
        switch keyword {
        case "drej":
            //Splitting string at ':' into the argument for the turn and the remaining code
            split = splitAtFirstOccurence(str: rest, separator: "\n")
            
            //Adding the Python command corresponding to 'Drej' and the argument to res
            res += "motors.turn(" + turnArgument(argument: split[0]) + ")\n"
            
            //Next round of the loop will use the remaining code
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        case "hvis":
            //Splitting string at '(' into the condition and the remaining code
            split = splitAtFirstOccurence(str: rest, separator: "(")
            
            //Adding the if-statemnt corresponding to the condition
            res += "if " + ifArgument(condition: split[0]).trimmingCharacters(in: .whitespacesAndNewlines) + ":\n"
            
            //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
            do {
                try split = extractGroup(codeSnippet: "("+split[1])
            } catch {
                print("Bad formatting")
            }
            
            //The code that the if-statement decides is converted to Python recursively and added
            res += indent(code: convertToPython(code: split[0]))
            
            //Next round of the loop will use the remaining code
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        case "ellers hvis":
            //Splitting string at '(' into the condition and the remaining code
            split = splitAtFirstOccurence(str: rest, separator: "(")
            
            //Adding the if-statemnt corresponding to the condition
            res += "elif " + ifArgument(condition: split[0]).trimmingCharacters(in: .whitespacesAndNewlines) + ":\n"
            
            //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
            do {
                try split = extractGroup(codeSnippet: "("+split[1])
            } catch {
                print("Bad formatting")
            }
            
            //The code that the if-statement decides is converted to Python recursively and added
            res += indent(code: convertToPython(code: split[0]))
            
            //Next round of the loop will use the remaining code
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
        case "ellers":
            //Splitting string at '(' into the condition and the remaining code
            split = splitAtFirstOccurence(str: rest, separator: "(")
            
            //Adding the if-statemnt corresponding to the condition
            res += "else:\n"
            
            //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
            do {
                try split = extractGroup(codeSnippet: "("+split[1])
            } catch {
                print("Bad formatting")
            }
            
            //The code that the if-statement decides is converted to Python recursively and added
            res += indent(code: convertToPython(code: split[0]))
            
            //Next round of the loop will use the remaining code
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
        case "gentag":
            //Splitting string at '(' into the condition and the remaining code
            split = splitAtFirstOccurence(str: rest, separator: "(")
            
            //Adding the for-statemnt corresponding to the condition
            res += forStatement(condition: split[0])
            
            //Splitting the remaining code into the codesegment that the if-statement decides and the remaining code
            do {
                try split = extractGroup(codeSnippet: "("+split[1])
            } catch {
                print("Bad formatting")
            }
            
            //The code that the if-statement decides is converted to Python recursively and added
            res += indent(code: convertToPython(code: split[0]))
            
            //Next round of the loop will use the remaining code
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)

        
        case "sig":
            //Splitting string at newline
            split = splitAtFirstOccurence(str: rest, separator: "\n")
            
            res += soundCommand(argument: split[0])
            
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
        case "drej":
            //Splitting string at newline
            split = splitAtFirstOccurence(str: rest, separator: "\n")
            
            res += turnCommand(argument: split[0])
            
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
        case "brems":
            res += stopCommand()
            
            trimmedCode = rest.trimmingCharacters(in: .whitespacesAndNewlines)
        
        case "tilbage":
            //Splitting string at newline
            split = splitAtFirstOccurence(str: rest, separator: "\n")
            
            res += backCommand(argument: split[0])
            
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
        
        case "frem":
            //Splitting string at newline
            split = splitAtFirstOccurence(str: rest, separator: "\n")
            
            res += forwardCommand(argument: split[0])
            
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
        case "tilbage":
            //Splitting string at newline
            split = splitAtFirstOccurence(str: rest, separator: "\n")
            
            res += backCommand(argument: split[0])
            
            trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
        default:
            print("Unhandled case:" + keyword)
            break
        }
    }
    
    return res
}



//Test
var code = "Hvis: altErFint ( \n \t Drej: 40 grader\n \t Drej: 30 grader \n Hvis: hej (\n\t\tDrej: 30 grader \n) \n)"

print("Code:")
print(code)

print("\nCompiles to:")
print(convertToPython(code: code))


