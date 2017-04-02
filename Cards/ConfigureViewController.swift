//
//  ConfigureViewController.swift
//  Cards
//
//  Created by Michael Buss Andersen on 19/03/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Cocoa

class ConfigureViewController: NSViewController {
//    Outlets
    @IBOutlet weak var presetOutlet: NSPopUpButton!
    @IBOutlet weak var drivingMotorsOutlet: NSPopUpButton!
    @IBOutlet weak var rotationMMOutlet: NSTextField!
    @IBOutlet weak var driveRotationOutlet: NSButton!
    
//    Variables
    var isConnected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        connectionEnablesInteraction()
    }
    
    @IBAction func connectAction(_ sender: Any) {
        let path = "/bin/sh" //Path
        let arguments = [Bundle.main.path(forResource: "Connect", ofType: "sh")]
        
        let task = Process.launchedProcess(launchPath: path, arguments: arguments as! [String])
        task.waitUntilExit()
        connectionEnablesInteraction()
    }
    
    @IBAction func PresetAction(_ sender: Any) {
        if let selected = sender as? NSPopUpButton {
        switch selected.titleOfSelectedItem! {
        case "Berta":
            print("Berta is selected")
            drivingMotorsOutlet.selectItem(withTitle: "B & C")
            rotationMMOutlet.stringValue = "300"
        case "Neutral":
            print("Nautral is selected")
            drivingMotorsOutlet.selectItem(withTitle: "B & C")
            rotationMMOutlet.stringValue = "100"
        default:
            break
        }
    }
    }
    
    func connectionEnablesInteraction() { // Sets up the UI for wether or not a connection is established
         if isConnected == true {
            print("Connection is OK")
            driveRotationOutlet.isEnabled = true
//            WindowController.runButtonIsEnabled(enable: true)
         } else {
            print("Connection is lost")
            driveRotationOutlet.isEnabled = false
        }
    }
    
}
