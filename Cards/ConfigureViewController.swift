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

    private var configureModel = ConfigureModel()
    
//    Variables
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let preset = UserDefaults.standard.string(forKey: "preset") {
            presetOutlet.selectItem(withTitle: preset)
            configureModel.choosePreset(preset)
        } else {
            presetOutlet.selectItem(withTitle: configureModel.chosenPreset)
            configureModel.choosePreset(configureModel.chosenPreset)
        }
        updatePreset()
//        connectionEnablesInteraction()
        
        rotationMMOutlet.stringValue = UserDefaults.standard.string(forKey: "rotationmm")!
        turnDegreesOutlet.stringValue = UserDefaults.standard.string(forKey: "rotationdeg")!
        
    }
    @IBAction func doneAction(_ sender: NSButton) {
        UserDefaults.standard.set(rotationMMOutlet?.stringValue, forKey: "rotationmm")
        UserDefaults.standard.set(turnDegreesOutlet?.stringValue, forKey: "rotationdeg")
        UserDefaults.standard.set(presetOutlet.selectedItem?.title, forKey: "preset")
        UserDefaults.standard.synchronize()
        dismissViewController(self)
    }
    
    @IBAction func PresetAction(_ sender: Any) {
        if let selected = sender as? NSPopUpButton {
            configureModel.choosePreset(selected.titleOfSelectedItem!)
            updatePreset()
        }
    }
    
    func updatePreset() {
        drivingMotorsOutlet.selectItem(withTitle: configureModel.drivingMotors)
        rotationMMOutlet.stringValue = configureModel.rotationMM
        turnDegreesOutlet.stringValue = configureModel.turnDegrees
        presetImageOutlet.image = configureModel.presetImage
    }
    
//    func connectionEnablesInteraction() { // Sets up the UI for wether or not a connection is established
//         if isConnected == true {
//            print("Connection is OK")
//            driveOneRotationOutlet.isEnabled = true
//            turnOneRotationOutlet.isEnabled = true
////            WindowController.runButtonIsEnabled(enable: true)
//         } else {
//            print("Connection is lost")
//            driveOneRotationOutlet.isEnabled = false
//            turnOneRotationOutlet.isEnabled = false
//        }
//    }
    
}
