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
    @IBOutlet weak var presetImageOutlet: NSImageView!
    @IBOutlet weak var presetOutlet: NSPopUpButton!
    @IBOutlet weak var drivingMotorsOutlet: NSPopUpButton!
    @IBOutlet weak var rotationMMOutlet: NSTextField!
    @IBOutlet weak var driveOneRotationOutlet: NSButton!
    @IBOutlet weak var turnDegreesOutlet: NSTextField!
    @IBOutlet weak var turnOneRotationOutlet: NSButton!

    
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
            turnDegreesOutlet.stringValue = "170"
            presetImageOutlet.image = #imageLiteral(resourceName: "Presets_Berta")
        case "Neutral":
            print("Nautral is selected")
            drivingMotorsOutlet.selectItem(withTitle: "B & C")
            rotationMMOutlet.stringValue = "100"
            turnDegreesOutlet.stringValue = "160"
            presetImageOutlet.image = #imageLiteral(resourceName: "Presets_Neutral")
        case "Pepperoni":
            print("Nautral is selected")
            drivingMotorsOutlet.selectItem(withTitle: "B & C")
            rotationMMOutlet.stringValue = "109"
            turnDegreesOutlet.stringValue = "153"
            presetImageOutlet.image = #imageLiteral(resourceName: "Presets_Pepperoni")
        case "Beethoven":
            print("Nautral is selected")
            drivingMotorsOutlet.selectItem(withTitle: "B & C")
            rotationMMOutlet.stringValue = "66"
            turnDegreesOutlet.stringValue = "164"
            presetImageOutlet.image = #imageLiteral(resourceName: "Presets_Beethoven")
        default:
            print("The selected preset is not fully configured")
            break
        }
    }
    }
    
    func connectionEnablesInteraction() { // Sets up the UI for wether or not a connection is established
         if isConnected == true {
            print("Connection is OK")
            driveOneRotationOutlet.isEnabled = true
            turnOneRotationOutlet.isEnabled = true
//            WindowController.runButtonIsEnabled(enable: true)
         } else {
            print("Connection is lost")
            driveOneRotationOutlet.isEnabled = false
            turnOneRotationOutlet.isEnabled = false
        }
    }
    
}
