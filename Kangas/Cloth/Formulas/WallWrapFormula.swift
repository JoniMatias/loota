//
//  WallWrap.swift
//  Kangas
//
//  Created by Joni Rajala on 8.12.2024.
//

import Foundation


extension Cloth {
 
    struct WallWrapOptions {
        let innerWallFill: Micron//Paljonko sisäseinää täytetään ylhäältä päin. Jos negatiivinen tai isompi kuin sisäkorkeus, niin käytetään sisäkorkeutta.
        
        let outerWallFill: Micron;//Paljonko ulkoseinää täytetään ylhäältä päin. Jos isompi kuin ulkokorkeus, niin käytetään ulkokorkeutta.
        
        let bottomSlack: Micron; //Jos koko ulkoseinä täytetään, niin paljonko alapintaan jätetään ylimääräistä. Ei tee mitään, jo outerWallFill on vähemmän kuin korkeus.
        
        init(outerWallFill: Micron = Micron(-1), innerWallFill: Micron = Micron(-1), bottomSlack: Micron = Micron(millimeters: 8)) {
            self.outerWallFill = outerWallFill
            self.bottomSlack = bottomSlack
            self.innerWallFill = innerWallFill
        }
        
        static func defaults() -> WallWrapOptions {
            return WallWrapOptions()
        }
    }
    
    /*
     Palauttaa stringing, jossa on svg-tiedoston sisältö.
     */
    static func createWallWrap(parameters: WallWrapOptions, box: BoxData, work: WorkSettings) -> [String]  {
        
        ClothState.reset()

        let internalOffset = Micron(0)//work.squareCorners ? work.materialThickness : Micron(0)
        
        let innerFillLength = parameters.innerWallFill > Micron(0) ? min(box.inner.height, parameters.innerWallFill) : box.inner.height
        let outerFillLength = parameters.outerWallFill > Micron(0) ? min(box.outer.height, parameters.outerWallFill) : box.outer.height
        
        let hasBottomSlack = parameters.bottomSlack > Micron(0) && outerFillLength >= box.outer.height
        
        
        var outerWalls: [Rect] = []
        outerWalls.append(Rect(origin: p(0,0), size: Size(width: box.outer.width, height: outerFillLength)))
        
        for i in 1...3 {
            outerWalls.append(Rect.withFold(from: outerWalls[i-1],
                                            towards: .right,
                                            distance: i%2==0 ? box.outer.width: box.outer.depth,
                                            fold: .hill,
                                            work: work))
        }
        
        let _/*outerFlap*/ = Flap.withFold(from: outerWalls[3], towards: .right, distance: outerFillLength / 6, fold: .hill, work: work)

        var rims: [Rect] = []
        for i in 0...3 {
            let rimShape = work.squareCorners ? Rect.self : Flap.self
            rims.append(rimShape.withFold(from: outerWalls[i],
                                          towards: .up,
                                          distance: work.materialThickness,
                                          fold: .hill,
                                          work: work))
        }

        var innerWalls: [Rect] = []
        for i in 0...3 {
            innerWalls.append(Rect.withFold(from: rims[i],
                                            towards: .up,
                                            distance: innerFillLength,
                                            margin: internalOffset,
                                            fold: .hill,
                                            work: work))
        }
        
        var innerSlacks: [Rect] = []
        
        for i in 0...3 {
            innerSlacks.append(Flap.withFold(from: innerWalls[i],
                                             towards: .up,
                                             distance: work.clothSlack,
                                             fold: .valley,
                                             work: work))
        }
        
        
        if hasBottomSlack {
            var bottomSlacks: [Rect] = []
            
            for i in 0...3 {
                print(i)
                bottomSlacks.append(Flap.withFold(from: outerWalls[i],
                                                  towards: .down,
                                                  distance: parameters.bottomSlack,
                                                  fold: .hill,
                                                  work: work))
            }
        }
        
        
        return [svgFrom(continuousLines: ContinuousLine.connect(lines: findCuttableLines(from: ClothState.allRects)))]
    }

    
}
