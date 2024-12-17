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
    
    required init(outer: Dimensions, work: WorkSettings) {
        self.outer = outer
        self.inner = type(of: self).calculateInnerDimensionsFrom(outer: outer, materialThickness: work.materialThickness)
        self.work = work
    }
    
    init(options: Kangas.BoxOptions, work: WorkSettings) {
        
        let inputDimensions = Dimensions(width: Micron(millimeters: options.width),
                                         height: Micron(millimeters: options.height),
                                         depth: Micron(millimeters: options.depth))
        
        
        if options.internalDimensions {
            outer = type(of: self).calculateOuterDimensionsFrom(inner: inputDimensions, materialThickness: work.materialThickness)
            inner = inputDimensions
        } else {
            outer = inputDimensions
            inner = type(of: self).calculateInnerDimensionsFrom(outer: inputDimensions, materialThickness: work.materialThickness)
        }
        
        self.work = work
        
    }
    
    func expanded(with: Micron, direction: [Direction3D]) -> Self {
        return type(of: self).init(outer: outer.expanded(with: with, except: direction), work: work)
    }
    
    
    class func calculateOuterDimensionsFrom(inner: Dimensions, materialThickness: Micron) -> Dimensions {
        
        let widthWalls = (isFaceOpen(.left) ? Micron(0) : materialThickness) + (isFaceOpen(.right) ? Micron(0) : materialThickness)
        let depthWalls = (isFaceOpen(.front) ? Micron(0) : materialThickness) + (isFaceOpen(.back) ? Micron(0) : materialThickness)
        let heightWalls = (isFaceOpen(.floor) ? Micron(0) : materialThickness) + (isFaceOpen(.ceiling) ? Micron(0) : materialThickness)
        
        
        let outerWidth =  inner.width  + widthWalls
        let outerDepth =  inner.depth  + depthWalls
        let outerHeight = inner.height + heightWalls
        
        return Dimensions(width: outerWidth, height: outerHeight, depth: outerDepth)
        
    }
    
    class func calculateInnerDimensionsFrom(outer: Dimensions, materialThickness: Micron) -> Dimensions {
        
        let widthWalls = (isFaceOpen(.left) ? Micron(0) : materialThickness) + (isFaceOpen(.right) ? Micron(0) : materialThickness)
        let depthWalls = (isFaceOpen(.front) ? Micron(0) : materialThickness) + (isFaceOpen(.back) ? Micron(0) : materialThickness)
        let heightWalls = (isFaceOpen(.floor) ? Micron(0) : materialThickness) + (isFaceOpen(.ceiling) ? Micron(0) : materialThickness)
        
        let innerWidth =  outer.width  - widthWalls
        let innerHeight =  outer.height  - heightWalls
        let innerDepth = outer.depth - depthWalls
        
        return Dimensions(width: innerWidth, height: innerHeight, depth: innerDepth)
        
    }
    
    
    /*
     Luokan sisällä oleva metodi, jonka tarkoitus on helpottaa saman nimisen luokkametodin käyttöä. Tätä ei kuulu overridata.
     */
    func isFaceOpen(_ face: Direction3D) -> Bool {
        return type(of: self).isFaceOpen(face)
    }
    
    
    //MARK: Overridable class methods
    /*
     Overridattava luokkafunktio, joka palauttaa luokan tyyppisen laatikon sivujen tilan.
     */
    class func isFaceOpen(_ face: Direction3D) -> Bool {
        return false
    }
    
    /*
     Tuottaa linkin boxes.py-ohjelmaan, joka generoi halutunlaisen laatikon.
     */
    func toUrl(work: WorkSettings) -> String {
        return "Ohjelma käytti BoxData-yläluokkaa luomaan laatikon. Sen olisi pitänyt käyttää jotain sen alaluokkaa."
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
