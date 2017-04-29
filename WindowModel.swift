//
//  WindowModel.swift
//  Cards
//
//  Created by Michael Buss Andersen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Foundation

struct WindowModel {
    func runPython(code: String){
        
        
        let task = Process()
        task.launchPath = "/usr/bin/ssh"
        //task.arguments = [Bundle.main.path(forResource: "Hello", ofType: "py")!]
        let pythonCode = Interpretter.compile(code: code)
        
        do {
            try pythonCode.write(toFile: "pyscript.py", atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
            print("Error saving python code to disk")
            return
        }
        
        task.arguments = ["robot@ev3dev.local", "-p maker", pythonCode]
        //print(pythonCode)
        task.launch()
        task.waitUntilExit()
    }
}
