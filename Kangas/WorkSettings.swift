//
//  WorkSettings.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation


class WorkSettings {
    
    let materialThickness: Micron
    let clothThickness: Micron
    let clothSlack: Micron //paljonko kangasta annetaan yli joka paikassa.
    
    let kerf: Micron
    
    init(options: Kangas.BoxOptions) {
        
        materialThickness = Micron(millimeters: options.materialThickness)
        clothThickness = Micron(millimeters: options.clothThickness)
        clothSlack = Micron(millimeters: options.clothSlack)
        
        kerf = Micron(millimeters: options.kerf)
        
    }
    
}
