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
        
        @Option(name: [.long], help:"Kuinka korkea kansi on. Ylhäältä päin mitattuna. (t.s. *ei* kuinka korkealta kansi alkaa). Milleinä.") var lidHeight: Double = -1.0
        @Option(name: [.long], help:"Kuinka korkealle huullos nouse pohjasta. Voi olla enintään kannen korkeuden verran (lidHeight). Milleinä.") var lipHeight: Double = -1.0
        
        @OptionGroup private var options: Kangas.BoxOptions
        @OptionGroup private var inoutOptions: Kangas.InoutOptions
        
        func run() {
            
            let workData = WorkSettings(options: options)
            let totalBox: BoxData
            
            if options.internalDimensions {
                //Lasketaan ulkopuolen mittasuhteet kuntoon ennen aloittamista. Tätä ei voi tehdä BoxDatan sisällä, koska huulloslaatikko käyttää useampaa sisäkkäistä laatikkoa.
                let internalBox = BoxData(options: options, work: workData)
                let outerDimension = Dimensions(width: internalBox.outer.width + 2*workData.materialThickness + 2*workData.clothThickness,
                                                height: internalBox.outer.height + 2*workData.materialThickness,
                                                depth: internalBox.outer.depth + 2*workData.materialThickness + 2*workData.clothThickness)
                totalBox = BoxData(outer: outerDimension, work: workData)
            } else {
                totalBox = BoxData(options: options, work: workData)
            }
            
            let lidHeightMicrons: Micron
            let lipHeightMicrons: Micron
            
            if lidHeight < 0 {
                lidHeightMicrons = totalBox.outer.height * 0.3
            } else {
                lidHeightMicrons = Micron(millimeters: lidHeight)
            }
            
            
            
            let lidBox = BoxOpenTopped(outer: Dimensions(width: totalBox.outer.width,
                                                        height: lidHeightMicrons,
                                                         depth: totalBox.outer.depth),
                                       work: workData)
            
            let baseBox = BoxOpenTopped(outer: Dimensions(width: totalBox.outer.width,
                                                          height: totalBox.outer.height - lidHeightMicrons,
                                                          depth: totalBox.outer.depth),
                                        work: workData)
            
            
            if lipHeight < 0 {
                lipHeightMicrons = baseBox.inner.height + (lidBox.inner.height / 2)
            } else {
                lipHeightMicrons = Micron(millimeters: lipHeight)
            }
            
            let lipBox = BoxOnlyWalls(outer:
                                        Dimensions(width: totalBox.inner.width - 2*workData.materialThickness - 2*workData.clothThickness,
                                                   height: baseBox.inner.height + lipHeightMicrons,
                                                   depth: totalBox.inner.depth - 2*workData.materialThickness - 2*workData.clothThickness),
                                      work: workData)
            
            let lipClothSettings = Cloth.WallWrapOptions(outerWallFill: lipBox.outer.height - baseBox.inner.height + workData.clothSlack, bottomSlack: Micron(0))
            
            let baseCloth = Cloth.createBasicWrap(box: baseBox, work: workData).first ?? ""
            let lidCloth = Cloth.createBasicWrap(box: lidBox, work: workData).first ?? ""
            let lipCloth = Cloth.createWallWrap(parameters: lipClothSettings, box: lipBox, work: workData).first ?? ""
            let floorCloth = Cloth.createInnerFloorCover(box: baseBox, work: workData).first ?? ""
            let ceilingCloth = Cloth.createInnerFloorCover(box: lidBox, work: workData).first ?? ""
            
            let boxesPyFileContent = """
            Pohja:
            \(baseBox.toBoxesPyAddress(work: workData))
            Kansi:
            \(lidBox.toBoxesPyAddress(work: workData))
            Huullos:
            \(lipBox.toBoxesPyAddress(work: workData))
            """
            
            inoutOptions.download(url: baseBox.toUrl(work: workData), suffix: "-laatikko-pohja.svg")
            inoutOptions.download(url: lidBox.toUrl(work: workData), suffix: "-laatikko-kansi.svg")
            inoutOptions.download(url: lipBox.toUrl(work: workData), suffix: "-laatikko-huullos.svg")
            
            inoutOptions.write(content: boxesPyFileContent, suffix: "-url.txt")
            inoutOptions.write(content: baseCloth, suffix: "-kangas-pohja.svg")
            inoutOptions.write(content: lidCloth, suffix: "-kangas-kansi.svg")
            inoutOptions.write(content: lipCloth, suffix: "-kangas-huullos.svg")
            inoutOptions.write(content: floorCloth, suffix: "-kabgas-pohjan_pohja.svg")
            inoutOptions.write(content: ceilingCloth, suffix: "-kangas-kannen_pohja.svg")
            
        }
    }
}

