//
//  WallWrap.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation


extension Cloth {
 
    struct WallWrapOptions {
        let outerWallFill: Micron;//Paljonko ulkoseinää täytetään ylhäältä päin. Jos isompi kuin korkeus, niin käytetään korkeutta.
        
        let bottomSlack: Micron; //Jos koko ulkoseinä täytetään, niin paljonko alapintaan jätetään ylimääräistä. Ei tee mitään, jo outerWallFill on vähemmän kuin korkeus.
        
        init(outerWallFill: Micron, bottomSlack: Micron) {
            self.outerWallFill = outerWallFill
            self.bottomSlack = bottomSlack
        }
        
        static func defaults() -> WallWrapOptions {
            return WallWrapOptions(outerWallFill: Micron(-1), bottomSlack: Micron(-1))
        }
    }
    
    /*
     Palauttaa stringing, jossa on svg-tiedoston sisältö.
     */
    static func createWallWrap(parameters: WallWrapOptions, box: BoxData, work: WorkSettings) -> [String]  {
        
        ClothState.reset()
        
        let rimShape = work.squareCorners ? Rect.self : Flap.self
        let internalOffset = work.squareCorners ? work.materialThickness : Micron(0)
        
        let outerFillLength = parameters.outerWallFill > Micron(0) ? min(box.outer.height, parameters.outerWallFill) : box.outer.height
        let hasBottomSlack = parameters.bottomSlack > Micron(0) && outerFillLength >= box.outer.height
        
        
        
        let outerWall1 = Rect(origin: p(0,0), size: Size(width: box.outer.width, height: outerFillLength))
        
        let outerWall2 = Rect.withFold(from: outerWall1,
                                       towards: .right,
                                       distance: box.outer.depth,
                                       fold: .hill,
                                       work: work)
        let outerWall3 = Rect.withFold(from: outerWall2,
                                       towards: .right,
                                       distance: box.outer.width,
                                       fold: .hill,
                                       work: work)
        let outerWall4 = Rect.withFold(from: outerWall3,
                                       towards: .right,
                                       distance: box.outer.depth,
                                       fold: .hill,
                                       work: work)
        
        
        let _/*outerFlap*/ = Flap.withFold(from: outerWall4, towards: .right, distance: outerFillLength / 6, fold: .hill, work: work)
        
        let rim1 = rimShape.withFold(from: outerWall1,
                                     towards: .up,
                                     distance: work.materialThickness,
                                     fold: .hill,
                                     work: work)
        let rim2 = rimShape.withFold(from: outerWall2,
                                     towards: .up,
                                     distance: work.materialThickness,
                                     fold: .hill,
                                     work: work)
        let rim3 = rimShape.withFold(from: outerWall3,
                                     towards: .up,
                                     distance: work.materialThickness,
                                     fold: .hill,
                                     work: work)
        let rim4 = rimShape.withFold(from: outerWall4,
                                     towards: .up,
                                     distance: work.materialThickness,
                                     fold: .hill,
                                     work: work)
        
        
        let innerWall1 = Rect.withFold(from: rim1,
                                       towards: .up,
                                       distance: box.inner.height,
                                       margin: internalOffset,
                                       fold: .hill,
                                       work: work)
        let innerWall2 = Rect.withFold(from: rim2,
                                       towards: .up,
                                       distance: box.inner.height,
                                       margin: internalOffset,
                                       fold: .hill,
                                       work: work)
        let innerWall3 = Rect.withFold(from: rim3,
                                       towards: .up,
                                       distance: box.inner.height,
                                       margin: internalOffset,
                                       fold: .hill,
                                       work: work)
        let innerWall4 = Rect.withFold(from: rim4,
                                       towards: .up,
                                       distance: box.inner.height,
                                       margin: internalOffset,
                                       fold: .hill,
                                       work: work)
        
        
        
        let _/*slack1*/ = Flap.withFold(from: innerWall1,
                                        towards: .up,
                                        distance: work.clothSlack,
                                        fold: .valley,
                                        work: work)
        let _/*slack2*/ = Flap.withFold(from: innerWall2,
                                        towards: .up,
                                        distance: work.clothSlack,
                                        fold: .valley,
                                        work: work)
        let _/*slack3*/ = Flap.withFold(from: innerWall3,
                                        towards: .up,
                                        distance: work.clothSlack,
                                        fold: .valley,
                                        work: work)
        let _/*slack4*/ = Flap.withFold(from: innerWall4,
                                        towards: .up,
                                        distance: work.clothSlack,
                                        fold: .valley,
                                        work: work)
        
        
        if hasBottomSlack {
            let bottomSlack1 = Flap.withFold(from: outerWall1,
                                             towards: .down,
                                             distance: parameters.bottomSlack,
                                             fold: .hill,
                                             work: work)
            let bottomSlack2 = Flap.withFold(from: outerWall2,
                                             towards: .down,
                                             distance: parameters.bottomSlack,
                                             fold: .hill,
                                             work: work)
            let bottomSlack3 = Flap.withFold(from: outerWall3,
                                             towards: .down,
                                             distance: parameters.bottomSlack,
                                             fold: .hill,
                                             work: work)
            let bottomSlack4 = Flap.withFold(from: outerWall4,
                                             towards: .down,
                                             distance: parameters.bottomSlack,
                                             fold: .hill,
                                             work: work)
        }
        
        
        return [svgFrom(lines: findCuttableLines(from: ClothState.allRects))]
    }

    
}
