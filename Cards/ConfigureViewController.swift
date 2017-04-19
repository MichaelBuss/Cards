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

    private var configure = ConfigureModel()
    
//    Variables
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        configure.choosePreset(configure.chosenPreset)
        updatePreset()
        connectionEnablesInteraction()
    }
    
    @IBAction func connectAction(_ sender: Any) {
        let path = "/bin/sh" //Path
        let arguments = [Bundle.main.path(forResource: "sshpass", ofType: "")]
        
        let task = Process.launchedProcess(launchPath: path, arguments: arguments as! [String])
        task.waitUntilExit()
        connectionEnablesInteraction()
    }
    
    @IBAction func PresetAction(_ sender: Any) {
        if let selected = sender as? NSPopUpButton {
            configure.choosePreset(selected.titleOfSelectedItem!)
            updatePreset()
        }
    }
    
    func updatePreset() {
        drivingMotorsOutlet.selectItem(withTitle: configure.drivingMotors)
        rotationMMOutlet.stringValue = configure.rotationMM
        turnDegreesOutlet.stringValue = configure.turnDegrees
        presetImageOutlet.image = configure.presetImage
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
