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
        
        let size = box.outer.expanded(with: work.kerf)
        
        let base = Rect(origin: p(0,0), size: Size(width: size.width, height: size.depth))
        let outerWallUp = Rect(from: base, towards: .up, distance: size.height)
        let outerWallRight = Rect(from: base, towards: .right, distance: size.height)
        let outerWallDown = Rect(from: base, towards: .down, distance: size.height)
        let outerWallLeft = Rect(from: base, towards: .left, distance: size.height)
        
        let rimUp = Flap(from: outerWallUp, towards: .up, distance: work.materialThickness)
        let rimRight = Flap(from: outerWallRight, towards: .right, distance: work.materialThickness)
        let rimDown = Flap(from: outerWallDown, towards: .down, distance: work.materialThickness)
        let rimLeft = Flap(from: outerWallLeft, towards: .left, distance: work.materialThickness)
        
        let _/*flapUpLeft*/ = Flap(from: outerWallUp, towards: .left, distance: size.height / 6)
        let _/*flapUpRight*/ = Flap(from: outerWallUp, towards: .right, distance: size.height / 6)
        let _/*flapDownLeft*/ = Flap(from: outerWallDown, towards: .left, distance: size.height / 6)
        let _/*flapDownRight*/ = Flap(from: outerWallDown, towards: .right, distance: size.height / 6)
        
        let innerWallUp = Rect(from: rimUp, towards: .up, distance: box.inner.height)
        let innerWallRight = Rect(from: rimRight, towards: .right, distance: box.inner.height)
        let innerWallDown = Rect(from: rimDown, towards: .down, distance: box.inner.height)
        let innerWallLeft = Rect(from: rimLeft, towards: .left, distance: box.inner.height)
        
        let _/*slackUp*/ = Flap(from: innerWallUp, towards: .up, distance: work.clothSlack)
        let _/*slackRight*/ = Flap(from: innerWallRight, towards: .right, distance: work.clothSlack)
        let _/*slackDown*/ = Flap(from: innerWallDown, towards: .down, distance: work.clothSlack)
        let _/*slackLeft*/ = Flap(from: innerWallLeft, towards: .left, distance: work.clothSlack)
     
        
        return [svgFrom(continuousLine: ContinuousLine(lines: findCuttableLines(from: ClothState.allRects)))]
    }

    
}


