//
//  BoxData.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation


class BoxData {
    let outer: Dimensions
    let inner: Dimensions
    let work: WorkSettings
    //let faces: [Direction3D: Bool] //Onko sivua olemassa? true: seinä, false: aukko
    
    required init(outer: Dimensions, work: WorkSettings) {
        self.outer = outer
        self.inner = BoxData.calculateInnerDimensionsFrom(outer: outer, faces: type(of: self).faces(), materialThickness: work.materialThickness)
        self.work = work
    }
    
    init(options: Kangas.BoxOptions, work: WorkSettings) {
        
        let inputDimensions = Dimensions(width: Micron(millimeters: options.width),
                                         height: Micron(millimeters: options.height),
                                         depth: Micron(millimeters: options.depth))
        
        
        if options.internalDimensions {
            outer = BoxData.calculateOuterDimensionsFrom(inner: inputDimensions, faces: type(of: self).faces(), materialThickness: work.materialThickness)
            inner = inputDimensions
        } else {
            outer = inputDimensions
            inner = BoxData.calculateInnerDimensionsFrom(outer: inputDimensions, faces: type(of: self).faces(), materialThickness: work.materialThickness)
        }
        
        self.work = work
        
    }
    
    func expanded(with: Micron, direction: [Direction3D]) -> Self {
        return type(of: self).init(outer: outer.expanded(with: with, except: direction), work: work)
    }
    
    
    class func calculateOuterDimensionsFrom(inner: Dimensions, faces: [Direction3D], materialThickness: Micron) -> Dimensions {
        
        let widthWalls = (faces.contains(.left) ? materialThickness : Micron(0)) + (faces.contains(.right) ? materialThickness : Micron(0))
        let depthWalls = (faces.contains(.front) ? materialThickness : Micron(0)) + (faces.contains(.back) ? materialThickness : Micron(0))
        let heightWalls = (faces.contains(.floor) ? materialThickness : Micron(0)) + (faces.contains(.ceiling) ? materialThickness : Micron(0))
        
        
        let outerWidth =  inner.width  + widthWalls
        let outerDepth =  inner.depth  + depthWalls
        let outerHeight = inner.height + heightWalls
        
        return Dimensions(width: outerWidth, height: outerHeight, depth: outerDepth)
        
    }
    
    class func calculateInnerDimensionsFrom(outer: Dimensions, faces: [Direction3D], materialThickness: Micron) -> Dimensions {
        
        let widthWalls = (faces.contains(.left) ? materialThickness : Micron(0)) +
            (faces.contains(.right) ? materialThickness : Micron(0))
        let depthWalls = (faces.contains(.front) ? materialThickness : Micron(0)) +
            (faces.contains(.back) ? materialThickness : Micron(0))
        let heightWalls = (faces.contains(.floor) ? materialThickness : Micron(0)) +
            (faces.contains(.ceiling) ? materialThickness : Micron(0))
        
        let innerWidth =  outer.width  - widthWalls
        let innerHeight =  outer.height  - heightWalls
        let innerDepth = outer.depth - depthWalls
        
        return Dimensions(width: innerWidth, height: innerHeight, depth: innerDepth)
        
    }
    
    

    
    class func faces() -> [Direction3D] {
        var foundFaces: [Direction3D] = []
        for face in Direction3D.allCases {
            if isFaceOpen(face) == false {
                foundFaces.append(face)
            }
        }
        return foundFaces
    }
    
    
    //MARK: Overridable methods
    class func isFaceOpen(_ face: Direction3D) -> Bool {
        return false
    }
    
    
    /*
     Tuottaa linkin boxes.py-ohjelmaan, joka generoi halutunlaisen laatikon.
     */
    func toBoxesPyAddress(work: WorkSettings) -> String {
        return "Ohjelma käytti BoxData-yläluokkaa luomaan laatikon. Sen olisi pitänyt käyttää jotain sen alaluokkaa."
    }
    
    func toUrl(work: WorkSettings) -> URL {
        let address = toBoxesPyAddress(work: work)
        return URL(string: address)!
    }
        
    
}





/*
 
 class BoxData {
     let outer: Dimensions
     let inner: Dimensions
     
     init(outer: Dimensions, work: WorkSettings) {
         self.outer = outer
         self.inner = type(of: self).calculateInnerDimensionsFrom(outer: outer, materialThickness: work.materialThickness, additionalWalls: Dimensions.zero)
     }
     
     
     init(options: Kangas.BoxOptions, work: WorkSettings, additionalWalls: Dimensions = Dimensions.zero) {
         
         let inputDimensions = Dimensions(width: Micron(millimeters: options.width),
                                          height: Micron(millimeters: options.height),
                                          depth: Micron(millimeters: options.depth))
         
         
         if options.internalDimensions {
             outer = type(of: self).calculateOuterDimensionsFrom(inner: inputDimensions, materialThickness: work.materialThickness, additionalWalls: additionalWalls)
             inner = inputDimensions
         } else {
             outer = inputDimensions
             inner = type(of: self).calculateInnerDimensionsFrom(outer: inputDimensions, materialThickness: work.materialThickness, additionalWalls: additionalWalls)
         }
         
         
         
     }
     
     func isFaceOpen(_ face: Direction3D) -> Bool {
         return false
     }
     
     class func calculateOuterDimensionsFrom(inner: Dimensions, materialThickness: Micron, additionalWalls: Dimensions) -> Dimensions {
         
         let outerWidth =  inner.width  + 2*materialThickness + additionalWalls.width
         let outerDepth =  inner.depth  + 2*materialThickness + additionalWalls.depth
         let outerHeight = inner.height + 2*materialThickness + additionalWalls.height
         
         return Dimensions(width: outerWidth, height: outerHeight, depth: outerDepth)
         
     }
     
     class func calculateInnerDimensionsFrom(outer: Dimensions, materialThickness: Micron, additionalWalls: Dimensions) -> Dimensions {
         
         let innerWidth =  outer.width  - 2*materialThickness - additionalWalls.width
         let innerDepth =  outer.depth  - 2*materialThickness - additionalWalls.depth
         let innerHeight = outer.height - 2*materialThickness - additionalWalls.height
         
         return Dimensions(width: innerWidth, height: innerHeight, depth: innerDepth)
         
     }
     
 }
*/
