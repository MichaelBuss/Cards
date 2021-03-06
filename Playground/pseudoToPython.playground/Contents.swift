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

let header = "#!/usr/bin/env python3\nfrom ev3dev.auto import *\n\n# Connect sensors.\nts = TouchSensor();    assert ts.connected\ncs = ColorSensor();    assert ts.connected\ncs.mode = 'COL-COLOR'\nus = UltrasonicSensor();    assert ts.connected\nus.mode = 'US-DIST-CM' # reports 'cm' even though the sensor measures 'mm'\nbtn = Button()\nmB = LargeMotor('outB')\nmC = LargeMotor('outC')\nmA = MediumMotor('outA')\n\n# Variables\nrotationmm = 183 # One wheel rotation equals x mm. From configure panel in app. Can be static for now\nrotationdeg = 210 # One wheel rotation in opposite directions equals the robot turning x degrees. From configure panel in app. Can be static for now\ndriveRatio = (360/(rotationmm))*10\nturnRatio = 360/rotationdeg\n\nSound.speak('Starting').wait()\n\ndef drive(unit=\"degrees\", amount=360, speed=50, direction=1):\n\t# unit = degrees, seconds, rotations, cm\n\t# amount = any int\n\t# speed = 0-100\n\t# direction = +/-1\n\tspeed = speed*direction*10 # Because ev3dev motors gros from -1000 to +1000\n\n\tif unit == \"degrees\":\n\t\t# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead\n\t\tmB.run_to_rel_pos(position_sp=amount*direction, speed_sp=speed, stop_action=\"brake\")\n\t\tmC.run_to_rel_pos(position_sp=amount*direction, speed_sp=speed, stop_action=\"brake\")\n\t\tmB.wait_while('running')\n\t\tmC.wait_while('running')\n\telif unit == \"seconds\":\n\t\tamount = amount*1000 # Because ev3dev uses milliseconds\n\t\tmB.run_timed(time_sp=amount, speed_sp=speed, stop_action=\"brake\")\n\t\tmC.run_timed(time_sp=amount, speed_sp=speed, stop_action=\"brake\")\n\t\tmB.wait_while('running')\n\t\tmC.wait_while('running')\n\telif unit == \"rotations\":\n\t\tmB.run_to_rel_pos(position_sp=amount*direction*360, speed_sp=speed, stop_action=\"brake\")\n\t\tmC.run_to_rel_pos(position_sp=amount*direction*360, speed_sp=speed, stop_action=\"brake\")\n\t\tmB.wait_while('running')\n\t\tmC.wait_while('running')\n\telif unit == \"cm\":\n\t\t# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead\n\t\tmB.run_to_rel_pos(position_sp=amount*direction*driveRatio, speed_sp=speed, stop_action=\"brake\")\n\t\tmC.run_to_rel_pos(position_sp=amount*direction*driveRatio, speed_sp=speed, stop_action=\"brake\")\n\t\tmB.wait_while('running')\n\t\tmC.wait_while('running')\n    elif unit=\"untilTouch\":\n        while not ts.value():\n            drive(unit=\"forever\")\n        brake()\n\telse:\n\t\tmB.run_forever(speed_sp=speed, stop_action=\"brake\")\n\t\tmC.run_forever(speed_sp=speed, stop_action=\"brake\")\n\n\ndef brake():\n    mB.stop(stop_action=\"brake\")\n    mC.stop(stop_action=\"brake\")\n\n\ndef turn(unit =\"degrees\" ,amount=90, speed=50, direction=1):\n\tif unit == \"degrees\":\n\t\tspeed = speed*10 # Because ev3dev motors gros from -1000 to +1000\n\t\t# run_to_rel_pos is the only one that don't react to negative speed, thus *direction on position instead\n\t\tmB.run_to_rel_pos(position_sp=amount*turnRatio*direction, speed_sp=speed, stop_action=\"brake\")\n\t\tmC.run_to_rel_pos(position_sp=amount*turnRatio*-direction, speed_sp=speed, stop_action=\"brake\")\n\t\tmB.wait_while('running')\n\t\tmC.wait_while('running')\n"






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
func turnCommand(argument: String) -> String {
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
func ifArgument(condition: String) -> String {
    var modifier = ""
    if condition.contains("ikke") {
        modifier = "not "
    }
    
    if condition.contains("farve") {
        if condition.contains("rød") {
            return modifier+"isColor(color=\"red\")"
        }
        if condition.contains("blå") {
            return modifier+"isColor(color=\"blue\")"
        }
        if condition.contains("grøn") {
            return modifier+"isColor(color=\"green\")"
        }
        if condition.contains("sort") {
            return modifier+"isColor(color=\"black\")"
        }
        if condition.contains("hvid") {
            return modifier+"isColor(color=\"white\")"
        }
        if condition.contains("gul") {
            return modifier+"isColor(color=\"yellow\")"
        }
        if condition.contains("brun") {
            return modifier+"isColor(color=\"brown\")"
        }
        //Tilføj selv flere farver her
    }
    if condition.contains("kontakt") {
        return modifier+"ts.value()"
    }
    print("An error occured. Condition "+condition+" unknown.")
    return condition
}

//Convert for/while argument to Python
func forStatement(condition: String) -> String {
    let trimCon = condition.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimCon.contains("gang") {
        let times = splitAtFirstOccurence(str: trimCon, separator: " ")[0]
        return "\nfor i in range("+times+"):\n"
    }
    if trimCon.contains("kontakt") {
        return "while not ts.value():\n"
    }
    
    print("An error occured. Condition "+condition+" unknown.")
    return condition
}

func soundCommand(argument: String) -> String {
    let arg = argument.trimmingCharacters(in: .whitespacesAndNewlines)
    return "\nSound.speak(\"" + arg + "\").wait()\n"
}

func stopCommand() -> String {
    return "\nbreak()\n"
}

func functionCommand(name: String) -> String {
    let trimName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    return "\ndef "+trimName+"():\n"
}

func functionCall(name: String) -> String {
    let trimName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    return "\n"+trimName+"()\n"
}

func backCommand(argument: String) -> String {
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
        return "\nwhile not ts.value():\n"+indent(code: "drive(unit=\"forever\", direction=-1)")+"break()\n"
    }
    print("An error occured. Argument "+argument+" unknown.")
    return argument
}

func forwardCommand(argument: String) -> String {
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
        return "\nwhile not ts.value():\n"+indent(code: "\ndrive(unit=\"forever\")")+"break()\n"
    }
    print("An error occured. Argument "+argument+" unknown.")
    return argument
}

func motorACommand(argument: String) -> String {
    if argument.contains("rotation") {
        let dist = splitAtFirstOccurence(str: argument, separator: " ")[0]
        if argument.contains("frem") {
            return "\nmotorA(rotations="+dist+", direction=1)\n"
        }
        else {
            return "\nmotorA(rotations="+dist+", direction=-1)\n"
        }
    }
    
    print("An error occured. Argument "+argument+" unknown.")
    return argument
}


//Converts pseudocode to Python
func convertToPython(code: String) -> String {
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
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "tilbage":
                    //Splitting string at newline
                    split = splitAtFirstOccurence(str: rest, separator: "\n")
                    
                    mainBody += backCommand(argument: split[0])
                    
                    trimmedCode = split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                case "motora":
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


func compile(code: String) -> String {
    return header + convertToPython(code: code)
}


//Test
var code = "frem: 10 cm\nhøjtaler: Hello\n\nNy funktion: toWall (\n\tfrem:til kontakt\n \ttilbage: 5 cm\n)\n\nFunktion:toWall\nDrej: 90 grader til højre\n frem: til kontakt\n\nGentag: 3 gange(\n\tDrej: 40 grader til højre\n\thøjtaler: Right\n\tDrej: 10 grader til venstre\n\thøjtaler: Left\n)\n\nFrem: til kontakt\nHvis: Farve er rød (\n\tMotorA: 1 rotation frem\n)\nEllers hvis: farve er sort(\n\tMotorA: 3 rotationer tilbage\n)\nEllers: (\n\tmotorA: 4 rotationer frem\n)\n\ntilbage: 5 cm\nDrej: 90 grader til venstre\n\nGentag: til kontakt (\n\tHvis: Farve er rød (\n\t\tBrems\n\t)\n\tEllers: (\n\t\tFrem\n\t)\n)\n\nTilbage: 5 cm\nDrej: 40 grader til højre\nTilbage: 1 sekund\n\nFrem: til kontakt\n Tilbage: 5 cm\nDrej: 90 grader til venstre"


print("#### Code ####")
print(code)


print("#### Errors ####")
let pythonCode = compile(code: code)

print("\n#### Compiles to ####")
print(pythonCode)






