//
//  BasicBox.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation
import ArgumentParser

extension Kangas {
    
    struct Avoloota: ParsableCommand {
        
        @Flag(help:"Tämä lippu pakottaa kankaan reunakiertokankaaksi.") var wallWrapCloth: Bool = false
        
        @OptionGroup private var options: Kangas.BoxOptions
        @OptionGroup private var inoutOptions: Kangas.InoutOptions
        
        func run() {
            
            let workData = WorkSettings(options: options)
            let totalBox = BoxOpenTopped(options: options, work: workData)
            

            let cloth: String
            if wallWrapCloth {
                cloth = Cloth.createWallWrap(parameters: Cloth.WallWrapOptions.defaults(), box: totalBox, work: workData).first ?? ""
                
                let ceilingCloth = Cloth.createOuterCeilingCover(box: totalBox, work: workData).first ?? ""
                inoutOptions.write(content: ceilingCloth, suffix: "-päällyskangas.svg")
            } else {
                cloth = Cloth.createBasicWrap(box: totalBox, work: workData).first ?? ""
            }
            let floorCloth = Cloth.createInnerFloorCover(box: totalBox, work: workData).first ?? ""
            
            let boxesPyFileContent = """
            Loota:
            \(totalBox.toUrl(work: workData))
            """
            
            inoutOptions.write(content: boxesPyFileContent, suffix: "-url.txt")
            inoutOptions.write(content: cloth, suffix: "-kangas.svg")
            inoutOptions.write(content: floorCloth, suffix: "-pohjakangas.svg")
            
        }
    }
}

