//
//  BasicBox.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation
import ArgumentParser

extension Kangas {
    
    struct Puristus: ParsableCommand {
        
        @Flag(help:"Tämä lippu pakottaa kankaan reunakiertokankaaksi.") var wallWrapCloth: Bool = false
        
        @OptionGroup private var options: Kangas.BoxOptions
        @OptionGroup private var inoutOptions: Kangas.InoutOptions
        
        func run() {
            
            let innerBox: BoxData
            let lidBox: BoxData
            let workData = WorkSettings(options: options)
            
            let boxSizeDifference = workData.materialThickness + workData.clothThickness*2
            
            if options.internalDimensions {
                innerBox = BoxOpenTopped.init(options: options, work: workData)
                lidBox = innerBox.expanded(with: boxSizeDifference,
                                           direction: [.back, .front, .left, .right])
            } else {
                lidBox = BoxOpenTopped.init(options: options, work: workData)
                innerBox = lidBox.expanded(with: -boxSizeDifference,
                                           direction: [.back, .front, .left, .right])
            }
            
            let innerCloth: [String]
            let lidCloth: [String]
            
            if wallWrapCloth {
                innerCloth = Cloth.createWallWrap(parameters: Cloth.WallWrapOptions.defaults(), box: innerBox, work: workData)
                lidCloth = Cloth.createWallWrap(parameters: Cloth.WallWrapOptions.defaults(), box: lidBox, work: workData)
                
                let outerTopCloth = Cloth.createOuterCeilingCover(box: lidBox, work: workData)
                let outerBottomCloth = Cloth.createOuterCeilingCover(box: innerBox, work: workData)
                inoutOptions.write(content: outerTopCloth, suffix: "-kangas-kansi-ulkopinta.svg")
                inoutOptions.write(content: outerBottomCloth, suffix: "-kangas-pohja-ulkopinta.svg")
            } else {
                innerCloth = Cloth.createBasicWrap(box: innerBox, work: workData)
                lidCloth = Cloth.createBasicWrap(box: lidBox, work: workData)
            }
            
            let innerLidCloth = Cloth.createInnerFloorCover(box: lidBox, work: workData)
            let innerInnderCloth = Cloth.createInnerFloorCover(box: innerBox, work: workData)
            
            
            
            
            
            
            let boxesPyFileContent = ["""
            Loota:
            \(innerBox.toBoxesPyAddress(work: workData))
            Kansi:
            \(lidBox.toBoxesPyAddress(work: workData))
            """]
            
            inoutOptions.download(url: innerBox.toUrl(work: workData), suffix: "-laatikko-sisus.svg")
            inoutOptions.download(url: lidBox.toUrl(work: workData), suffix: "-laatikko-kansi.svg")
            
            inoutOptions.write(content: innerCloth, suffix: "-kangas-laatikko")
            inoutOptions.write(content: lidCloth, suffix: "-kangas-kansi")
            inoutOptions.write(content: innerLidCloth, suffix: "-kangas-kansi-sisäpinta")
            inoutOptions.write(content: innerInnderCloth, suffix: "-kangas-laatikko-sisäpinta")
            inoutOptions.write(content: boxesPyFileContent, suffix: "-url.txt")
            
        }
    }
}

