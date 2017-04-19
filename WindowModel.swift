//
//  WindowModel.swift
//  Cards
//
//  Created by Michael Buss Andersen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Foundation

struct WindowModel {
    func runPython(){
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = [Bundle.main.path(forResource: "Hello", ofType: "py")!]
        task.launch()
        task.waitUntilExit()
    }
}
