//
//  BasicBox.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation
import ArgumentParser

extension Kangas {
    
    struct Huullos: ParsableCommand {
        
        @Flag(help:"Tämä lippu pakottaa kankaan reunakiertokankaaksi.") var wallWrapCloth: Bool = false
        
        @Option(name: [.long], help:"Kuinka korkea kansi on. Ylhäältä päin mitattuna. (t.s. *ei* kuinka korkealta kansi alkaa). Jos tätä ei aseteta, kansi on 30% koko korkeudesta. Milleinä.") var lidHeight: Double?
        @Option(name: [.long], help:"Kuinka korkealle huullos nouse pohjasta. Voi olla enintään kannen korkeuden verran (lidHeight). Oletuksena puolet kannen korkeudesta. Milleinä.") var lipHeight: Double?
        @Option(name: [.long], help:"Huulloksen materiaalin paksuus. Oletuksena sama kuin --material-thickness. Milleinä.") var lipThickness: Double?
        
        @OptionGroup private var options: Kangas.BoxOptions
        @OptionGroup private var inoutOptions: Kangas.InoutOptions
        
        func run() {
            
            let workData = WorkSettings(options: options)
            var internalOptions = options
            internalOptions.materialThickness = lipThickness != nil ? lipThickness! : options.materialThickness
            let internalWorkData = WorkSettings(options: internalOptions)
            let totalBox: BoxData
            
            if options.internalDimensions {
                //Lasketaan ulkopuolen mittasuhteet kuntoon ennen aloittamista. Tätä ei voi tehdä BoxDatan sisällä, koska huulloslaatikko käyttää useampaa sisäkkäistä laatikkoa.
                let internalBox = BoxData(options: internalOptions, work: internalWorkData)
                let outerDimension = Dimensions(width: internalBox.outer.width + 2*workData.materialThickness + 2*workData.clothThickness,
                                                height: internalBox.outer.height + 2*workData.materialThickness,
                                                depth: internalBox.outer.depth + 2*workData.materialThickness + 2*workData.clothThickness)
                totalBox = BoxData(outer: outerDimension, work: workData)
            } else {
                totalBox = BoxData(options: options, work: workData)
            }
            
            let lidHeightMicrons: Micron
            let lipHeightMicrons: Micron
            
            if lidHeight == nil {
                lidHeightMicrons = totalBox.outer.height * 0.3
            } else {
                lidHeightMicrons = Micron(millimeters: lidHeight!)
            }
            
            
            
            let lidBox = BoxOpenTopped(outer: Dimensions(width: totalBox.outer.width,
                                                        height: lidHeightMicrons,
                                                         depth: totalBox.outer.depth),
                                       work: workData)
            
            let baseBox = BoxOpenTopped(outer: Dimensions(width: totalBox.outer.width,
                                                          height: totalBox.outer.height - lidHeightMicrons,
                                                          depth: totalBox.outer.depth),
                                        work: workData)
            
            
            if lipHeight == nil {
                lipHeightMicrons = lidBox.inner.height / 2
            } else {
                lipHeightMicrons = Micron(millimeters: lipHeight!)
                if lipHeightMicrons > lidBox.inner.height {
                    print("Huom! Parametri '--lipHeight' on korkeampi kuin kansi.")
                }
            }
            
            let lipBox = BoxOnlyWalls(outer:
                                        Dimensions(width: totalBox.inner.width - 2*workData.clothThickness,
                                                   height: baseBox.inner.height + lipHeightMicrons,
                                                   depth: totalBox.inner.depth - 2*workData.clothThickness),
                                      work: workData)
            
            let lipClothSettings = Cloth.WallWrapOptions(outerWallFill: lipBox.outer.height - baseBox.inner.height + workData.clothSlack, bottomSlack: Micron(0))

            let baseCloth: [String]
            let lidCloth: [String]
            if wallWrapCloth {
                baseCloth = Cloth.createWallWrap(parameters: Cloth.WallWrapOptions(innerWallFill: Micron(millimeters: 10)), box: baseBox, work: workData)
                lidCloth = Cloth.createWallWrap(parameters: .defaults(), box: lidBox, work: workData)
                let baseCeiling = Cloth.createOuterCeilingCover(box: baseBox, work: workData)
                let lidCeiling = Cloth.createOuterCeilingCover(box: lidBox, work: workData)
                
                inoutOptions.write(content: baseCeiling, suffix: "-laatikko-pohjan-yläpinta")
                inoutOptions.write(content: lidCeiling, suffix: "laatikko-kannen-yläpinta")
            } else {
                let baseBoxClothParameters = Cloth.BasicWrapOptions.init(innerWallFill: Micron(millimeters: 10))
                
                baseCloth = Cloth.createBasicWrap(parameters: baseBoxClothParameters, box: baseBox, work: workData)
                lidCloth = Cloth.createBasicWrap(parameters: .defaults(), box: lidBox, work: workData)
            }
            
            let lipCloth = Cloth.createWallWrap(parameters: lipClothSettings, box: lipBox, work: workData)
            let floorCloth = Cloth.createInnerFloorCover(box: baseBox, work: workData)
            let ceilingCloth = Cloth.createInnerFloorCover(box: lidBox, work: workData)
            
            let boxesPyFileContent = ["""
            Pohja:
            \(baseBox.toBoxesPyAddress(work: workData))
            Kansi:
            \(lidBox.toBoxesPyAddress(work: workData))
            Huullos:
            \(lipBox.toBoxesPyAddress(work: workData))
            """]
            
            inoutOptions.download(url: baseBox.toUrl(work: workData), suffix: "-laatikko-pohja.svg")
            inoutOptions.download(url: lidBox.toUrl(work: workData), suffix: "-laatikko-kansi.svg")
            inoutOptions.download(url: lipBox.toUrl(work: workData), suffix: "-laatikko-huullos.svg")
            
            inoutOptions.write(content: boxesPyFileContent, suffix: "-url.txt")
            inoutOptions.write(content: baseCloth, suffix: "-kangas-pohja.svg")
            inoutOptions.write(content: lidCloth, suffix: "-kangas-kansi.svg")
            inoutOptions.write(content: lipCloth, suffix: "-kangas-huullos.svg")
            inoutOptions.write(content: floorCloth, suffix: "-kangas-pohjan-sisäpinta.svg")
            inoutOptions.write(content: ceilingCloth, suffix: "-kangas-kannen-sisäpinta.svg")
            
        }
    }
}

