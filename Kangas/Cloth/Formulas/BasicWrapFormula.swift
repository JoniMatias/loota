//
//  BasicWrap.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation

extension Cloth {

    /*
     Palauttaa stringin, jossa on svg-tiedoston sisältö.
     */
    static func createBasicWrap(box: BoxData, work: WorkSettings) -> [String] {
        
        ClothState.reset()
        
        let size = box.outer
        
        print("Ulkomitat: \(box.outer) sisämitat: \(box.inner)")
        
        let base = Rect(origin: p(0,0), size: Size(width: size.width, height: size.depth))
        
        let outerWallUp = Rect.withHillEdge(from: base, towards: .up, distance: size.height, work: work)
        let outerWallRight = Rect.withHillEdge(from: base, towards: .right, distance: size.height, work: work)
        let outerWallDown = Rect.withHillEdge(from: base, towards: .down, distance: size.height, work: work)
        let outerWallLeft = Rect.withHillEdge(from: base, towards: .left, distance: size.height, work: work)
        
        let rimUp = Flap.withHillEdge(from: outerWallUp, towards: .up, distance: work.materialThickness + work.clothThickness, work: work)
        let rimRight = Flap.withHillEdge(from: outerWallRight, towards: .right, distance: work.materialThickness + work.clothThickness, work: work)
        let rimDown = Flap.withHillEdge(from: outerWallDown, towards: .down, distance: work.materialThickness + work.clothThickness, work: work)
        let rimLeft = Flap.withHillEdge(from: outerWallLeft, towards: .left, distance: work.materialThickness + work.clothThickness, work: work)
        
        let _/*flapUpLeft*/ = Flap.withHillEdge(from: outerWallUp, towards: .left, distance: size.height / 6, work: work)
        let _/*flapUpRight*/ = Flap.withHillEdge(from: outerWallUp, towards: .right, distance: size.height / 6, work: work)
        let _/*flapDownLeft*/ = Flap.withHillEdge(from: outerWallDown, towards: .left, distance: size.height / 6, work: work)
        let _/*flapDownRight*/ = Flap.withHillEdge(from: outerWallDown, towards: .right, distance: size.height / 6, work: work)
        
        let innerWallUp = Rect.withHillEdge(from: rimUp, towards: .up, distance: box.inner.height, work: work)
        let innerWallRight = Rect.withHillEdge(from: rimRight, towards: .right, distance: box.inner.height, work: work)
        let innerWallDown = Rect.withHillEdge(from: rimDown, towards: .down, distance: box.inner.height, work: work)
        let innerWallLeft = Rect.withHillEdge(from: rimLeft, towards: .left, distance: box.inner.height, work: work)
        
        let _/*slackUp*/ = Flap(from: innerWallUp, towards: .up, distance: work.clothSlack)
        let _/*slackRight*/ = Flap(from: innerWallRight, towards: .right, distance: work.clothSlack)
        let _/*slackDown*/ = Flap(from: innerWallDown, towards: .down, distance: work.clothSlack)
        let _/*slackLeft*/ = Flap(from: innerWallLeft, towards: .left, distance: work.clothSlack)
     
        
        return [svgFrom(continuousLine: ContinuousLine(lines: findCuttableLines(from: ClothState.allRects)))]
    }

    
}


