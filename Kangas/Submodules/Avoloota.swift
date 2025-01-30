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
        
        @Option(name: [.long], help:"Kuinka pitkälle kangas menee laatikon sisäseinää pitkin. Milleinä.") var innerWallFill: Double = Double.greatestFiniteMagnitude
        
        @OptionGroup private var options: Kangas.BoxOptions
        @OptionGroup private var inoutOptions: Kangas.InoutOptions
        
        func run() {
            
            let workData = WorkSettings(options: options)
            let totalBox = BoxOpenTopped(options: options, work: workData)

            let cloth: [String]
            if wallWrapCloth {
                cloth = Cloth.createWallWrap(parameters: Cloth.WallWrapOptions.init(innerWallFill: Micron(millimeters: innerWallFill)), box: totalBox, work: workData)
                
                let ceilingCloth = Cloth.createOuterCeilingCover(box: totalBox, work: workData)
                inoutOptions.write(content: ceilingCloth, suffix: "-kangas-yläpinta.svg")
            } else {
                cloth = Cloth.createBasicWrap(parameters: Cloth.BasicWrapOptions(innerWallFill: Micron(millimeters: innerWallFill)), box: totalBox, work: workData)
            }
            let floorCloth = Cloth.createInnerFloorCover(box: totalBox, work: workData)
            
            let boxesPyFileContent = ["""
            Loota:
            \(totalBox.toBoxesPyAddress(work: workData))
            """]
            
            inoutOptions.download(url: totalBox.toUrl(work: workData), suffix: "-laatikko.svg")
            
            inoutOptions.write(content: boxesPyFileContent, suffix: "-url.txt")
            inoutOptions.write(content: cloth, suffix: "-kangas.svg")
            inoutOptions.write(content: floorCloth, suffix: "-pohjakangas.svg")
            
        }
    }
}

