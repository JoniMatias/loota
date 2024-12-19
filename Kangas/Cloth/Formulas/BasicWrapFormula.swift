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
        
        let rimShape = work.squareCorners ? Rect.self : Flap.self
        let innerWallOffset = work.squareCorners ? work.materialThickness : Micron(0)
        
        let base = Rect(origin: p(0,0), size: Size(width: size.width, height: size.depth))
        
        let outerWallUp = Rect.withFold(from: base, towards: .up, distance: size.height, fold: .hill, work: work)
        let outerWallRight = Rect.withFold(from: base, towards: .right, distance: size.height, fold: .hill, work: work)
        let outerWallDown = Rect.withFold(from: base, towards: .down, distance: size.height, fold: .hill, work: work)
        let outerWallLeft = Rect.withFold(from: base, towards: .left, distance: size.height, fold: .hill, work: work)
        
        let rimUp = rimShape.withFold(from: outerWallUp, towards: .up, distance: work.materialThickness + work.clothThickness, fold: .hill, work: work)
        let rimRight = rimShape.withFold(from: outerWallRight, towards: .right, distance: work.materialThickness + work.clothThickness, fold: .hill, work: work)
        let rimDown = rimShape.withFold(from: outerWallDown, towards: .down, distance: work.materialThickness + work.clothThickness, fold: .hill, work: work)
        let rimLeft = rimShape.withFold(from: outerWallLeft, towards: .left, distance: work.materialThickness + work.clothThickness, fold: .hill, work: work)
        
        let _/*flapUpLeft*/ = Flap.withFold(from: outerWallUp, towards: .left, distance: size.height / 6, fold: .hill, work: work)
        let _/*flapUpRight*/ = Flap.withFold(from: outerWallUp, towards: .right, distance: size.height / 6, fold: .hill, work: work)
        let _/*flapDownLeft*/ = Flap.withFold(from: outerWallDown, towards: .left, distance: size.height / 6, fold: .hill, work: work)
        let _/*flapDownRight*/ = Flap.withFold(from: outerWallDown, towards: .right, distance: size.height / 6, fold: .hill, work: work)
        
        let innerWallUp = Rect.withFold(from: rimUp, towards: .up, distance: box.inner.height, margin: innerWallOffset, fold: .hill, work: work)
        let innerWallRight = Rect.withFold(from: rimRight, towards: .right, distance: box.inner.height, margin: innerWallOffset,  fold: .hill, work: work)
        let innerWallDown = Rect.withFold(from: rimDown, towards: .down, distance: box.inner.height, margin: innerWallOffset,  fold: .hill, work: work)
        let innerWallLeft = Rect.withFold(from: rimLeft, towards: .left, distance: box.inner.height, margin: innerWallOffset,  fold: .hill, work: work)

        let _/*slackUp*/ = Flap.withFold(from: innerWallUp, towards: .up, distance: work.clothSlack, fold: .valley, work: work)
        let _/*slackRight*/ = Flap.withFold(from: innerWallRight, towards: .right, distance: work.clothSlack, fold: .valley, work: work)
        let _/*slackDown*/ = Flap.withFold(from: innerWallDown, towards: .down, distance: work.clothSlack, fold: .valley, work: work)
        let _/*slackLeft*/ = Flap.withFold(from: innerWallLeft, towards: .left, distance: work.clothSlack, fold: .valley, work: work)

        return [svgFrom(continuousLines: ContinuousLine.connect(lines: findCuttableLines(from: ClothState.allRects)))]
    }

    
}


