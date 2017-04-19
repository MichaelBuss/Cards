//
//  ConfigureModel.swift
//  Cards
//
//  Created by Michael Buss Andersen on 18/04/2017.
//  Copyright © 2017 NoobLabs. All rights reserved.
//

import Foundation
import AppKit

struct ConfigureModel {
    
    var chosenPreset = "Default"
    
    var drivingMotors = "B & C"
    var rotationMM = "100"
    var turnDegrees = "100"
    var presetImage = #imageLiteral(resourceName: "Presets_Neutral")
    
    mutating func choosePreset(_ preset: String) {
        switch preset {
        case "Berta":
            chosenPreset = "Berta"
            print("\(chosenPreset) chosen")
            drivingMotors = "B & C"
            rotationMM = "300"
            turnDegrees = "170"
            presetImage = #imageLiteral(resourceName: "Presets_Berta")
            
        case "Beethoven":
            chosenPreset = "Beethoven"
            print("\(chosenPreset) chosen")
            drivingMotors = "B & C"
            rotationMM = "200"
            turnDegrees = "150"
            presetImage = #imageLiteral(resourceName: "Presets_Beethoven")
            
        case "Pepperoni":
            chosenPreset = "Pepperoni"
            print("\(chosenPreset) chosen")
            drivingMotors = "B & C"
            rotationMM = "400"
            turnDegrees = "200"
            presetImage = #imageLiteral(resourceName: "Presets_Pepperoni")
            
        default:
            chosenPreset = "Default"
            print("\(chosenPreset) chosen")
            drivingMotors = "B & C"
            rotationMM = "100"
            turnDegrees = "100"
            presetImage = #imageLiteral(resourceName: "Presets_Neutral")
        }
    }
}
