//
//  WindowModel.swift
//  Cards
//
//  Created by Michael Buss Andersen on 19/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Foundation

struct WindowModel {
    func runPython(code: String, compiled:@escaping (() -> Void), finished:@escaping (() -> Void)){
        
        
        /*
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
        */
        
        DispatchQueue.global(qos: .background).async {
            let rotmm = UserDefaults.standard.string(forKey: "rotationmm")!
            let rotdeg = UserDefaults.standard.string(forKey: "rotationdeg")!
            
            let settings = CompileSettings(rotationmm: rotmm, rotationdeg: rotdeg)
            let pyCode = Interpretter.compile(code: code, settings: settings)
            
            do {
                try pyCode.write(toFile: "pyscript.py", atomically: true, encoding: String.Encoding.utf8)
            } catch _ {
                print("Could not save code to disk")
            }
            
            
            let session = NMSSHSession.connect(toHost: "ev3dev.local", withUsername: "robot")
            
            if (session?.isConnected)! {
                session?.authenticate(byPassword: "maker")
            }
            
            if (session?.isAuthorized)! {
                do {
                    let response = session?.channel.uploadFile("./pyscript.py", to: "runner.py")
                    print(response ?? "")
                    DispatchQueue.main.async {
                        compiled();
                    }
                    let res = try session?.channel.execute("chmod +x runner.py")
                    print(res ?? "")
                    try session?.channel.execute("python3 runner.py")
                    
                } catch _ {
                    print("Failed to send to machine")
                }
            }
            
            DispatchQueue.main.async {
                finished();
            }
            
            session?.disconnect()
        }

    }
}
