//
//  SetCard.swift
//  CardGame
//
//  Created by Wojtek on 7/18/14.
//
//

import Foundation



class SetCard: Card {
    //MARK: Properties
    let NUMBER_OF_MATCHING_CARDS = 3
    var color:Color
    var shape:Shape
    var count:Count
    var shade:Shade
    
    
    //MARK: Initializer
    init(color:Color, shape: Shape, count: Count, shade:Shade) {
        self.color = color
        self.shape = shape
        self.count = count
        self.shade = shade
    }
    
    
    //MARK: Other functions
    override func match(cards: [Card]) -> Int {
        var score = 0
        var colors: [Color] = [self.color]
        var shapes: [Shape] = [self.shape]
        var counts: [Count] = [self.count]
        var shades: [Shade] = [self.shade]
        
        for otherCard in cards as [SetCard] {
            if (!contains(colors, otherCard.color)) {
                colors.append(otherCard.color)
            }
            if (!contains(shapes, otherCard.shape)) {
                shapes.append(otherCard.shape)
            }
            if (!contains(counts, otherCard.count)) {
                counts.append(otherCard.count)
            }
            if (!contains(shades, otherCard.shade)) {
                shades.append(otherCard.shade)
            }
        }
        
        if (colors.count == 1 || colors.count == NUMBER_OF_MATCHING_CARDS)
            && (shapes.count == 1 || shapes.count == NUMBER_OF_MATCHING_CARDS)
            && (counts.count == 1 || counts.count == NUMBER_OF_MATCHING_CARDS)
            && (shades.count == 1 || shades.count == NUMBER_OF_MATCHING_CARDS) {
                score = 4
        }
        NSLog("Counting points - SET")
        return score
    }
    
    
    //MARK: Enumerators
    enum Color {
        case Red, Green, Purple
        static let allValues = [Red, Green, Purple]
    }
    
    enum Shape: String {
        case Diamond="◼︎", Squiggle="▲", Oval="●"
        static let allValues = [Diamond, Squiggle, Oval]
    }
    
    enum Count: Int {
        case One=1, Two=2, Three=3
        static let allValues = [One, Two, Three]
    }
    
    enum Shade {
        case Solid, Striped, Open
        static let allValues = [Solid, Striped, Open]
    }
    
}