//
//  FloorCoverFormula.swift
//  Kangas
//
//  Created by Joni Rajala on 9.12.2024.
//

import Foundation


extension Cloth {
    
    /*
     Palauttaa stringing, jossa on svg-tiedoston sisältö.
     */
    static func createInnerFloorCover(box: BoxData, work: WorkSettings) -> [String]  {
        
        ClothState.reset()
        
        let _/*floor*/ = Rect(origin: p(0,0), size: Size(width: box.inner.width, height: box.inner.depth))
        
        return [svgFrom(lines: findCuttableLines(from: ClothState.allRects))]
    }
    
    
    static func createOuterCeilingCover(box: BoxData, work: WorkSettings) -> [String] {
        ClothState.reset()
        
        let _/*ceiling*/ = Rect(origin: p(0,0), size: Size(width: box.outer.width, height: box.outer.depth))
        
        return [svgFrom(lines: findCuttableLines(from: ClothState.allRects))]
    }

    
}
