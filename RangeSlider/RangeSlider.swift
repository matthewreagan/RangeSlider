//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Matt Reagan on 10/29/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

import Foundation
import Cocoa

let verticalGradientDegrees: CGFloat = -90.0
let verticalShadowPadding: CGFloat = 4.0

struct SelectionRange {
    var start: Double
    var end: Double
}

enum DraggedSlider {
    case start
    case end
}

class RangeSlider: NSView {
    
    //MARK: - Properties -
    
    var selection: SelectionRange = SelectionRange(start: 0.0, end: 0.75)
    var initialMouseDown: CGPoint = .zero
    var currentSliderDragging: DraggedSlider? = nil
    
    //MARK: - Appearance -
    
    var sliderGradient: NSGradient {
        get {
            let backgroundStart = NSColor(white: 0.92, alpha: 1.0)
            let backgroundEnd =  NSColor(white: 0.80, alpha: 1.0)
            let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
            assert(barBackgroundGradient != nil, "Couldn't generate gradient.")
            
            return barBackgroundGradient!
        }
    }
    
    var barBackgroundGradient: NSGradient {
        get {
            let backgroundStart = NSColor(white: 0.85, alpha: 1.0)
            let backgroundEnd =  NSColor(white: 0.70, alpha: 1.0)
            let barBackgroundGradient = NSGradient(starting: backgroundStart, ending: backgroundEnd)
            assert(barBackgroundGradient != nil, "Couldn't generate gradient.")
            
            return barBackgroundGradient!
        }
    }
    
    var barFillGradient: NSGradient {
        get {
            let fillStart = NSColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
            let fillEnd = NSColor(red: 1.0, green: 196/255.0, blue: 0.0, alpha: 1.0)
            let barFillGradient = NSGradient(starting: fillStart, ending: fillEnd)
            assert(barFillGradient != nil, "Couldn't generate gradient.")
            
            return barFillGradient!
        }
    }
    
    var barStrokeColor: NSColor {
        get {
            return NSColor(white: 0.0, alpha: 0.25)
        }
    }
    
    var barFillStrokeColor: NSColor {
        get {
            return NSColor(red: 1.0, green: 170/255.0, blue: 16/255.0, alpha: 0.70)
        }
    }
    
    let sliderWidth = CGFloat(8.0)
    
    var sliderHeight: CGFloat {
        get {
            return NSHeight(bounds) - verticalShadowPadding
        }
    }
    
    //MARK: - Event -
    
    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        
        if NSPointInRect(point, frameForStartSlider()) {
            currentSliderDragging = .start
        } else if NSPointInRect(point, frameForEndSlider()) {
            currentSliderDragging = .end
        } else {
            currentSliderDragging = nil
        }
        
        initialMouseDown = point
    }
    
    override func mouseDragged(with event: NSEvent) {
        if currentSliderDragging != nil {
            let point = convert(event.locationInWindow, from: nil)
            let x = Double(point.x / NSWidth(bounds))
            
            if currentSliderDragging! == .start {
                selection = SelectionRange(start: x, end: max(selection.end, x))
            } else {
                selection = SelectionRange(start: min(selection.start, x), end: x)
            }
            
            setNeedsDisplay(bounds)
        }
    }
    
    //MARK: - Utility -
    
    func crispLineRect(_ rect: NSRect) -> NSRect {
        var newRect = NSIntegralRect(rect)
        newRect.origin.x += 0.5
        newRect.origin.y += 0.5
        
        return newRect
    }
    
    func frameForStartSlider() -> NSRect {
        let halfSliderWidth = (sliderWidth / 2.0)
        var x = max(CGFloat(selection.start) * NSWidth(bounds), halfSliderWidth)
        x -= halfSliderWidth
        
        return crispLineRect(NSMakeRect(x, (NSHeight(bounds) - sliderHeight) / 2.0, sliderWidth, sliderHeight))
    }
    
    func frameForEndSlider() -> NSRect {
        let width = NSWidth(bounds)
        var x = min(CGFloat(selection.end) * width, width - sliderWidth)
        x -= (sliderWidth / 2.0)
        
        return crispLineRect(NSMakeRect(x, (NSHeight(bounds) - sliderHeight) / 2.0, sliderWidth, sliderHeight))
    }
    
    //MARK: - NSView Overrides -
    
    override func draw(_ dirtyRect: NSRect) {
        let width = NSWidth(bounds)
        let height = NSHeight(bounds)
        
        assert(width > (height * 2), "Range control expects a reasonable width to height ratio, width should be greater than twice the height at least.");
        assert(width > (sliderWidth * 2.0), "Width must be able to accommodate two range sliders.")
        
        let barHeight = round((height - verticalShadowPadding) * (2.0 / 3.0))
        let barY = floor((height - barHeight) / 2.0)
        
        let startSliderFrame = frameForStartSlider()
        let endSliderFrame = frameForEndSlider()
        
        let barRect = crispLineRect(NSMakeRect(0, barY, width, barHeight))
        let selectedRect = crispLineRect(NSMakeRect(CGFloat(selection.start) * width,
                                                    barY,
                                                    width * CGFloat(selection.end - selection.start),
                                                    barHeight))
        
        let radius = barHeight / 3.0;
        
        let framePath = NSBezierPath(roundedRect: barRect, xRadius: radius, yRadius: radius)
        let selectedPath = NSBezierPath(roundedRect: selectedRect, xRadius: radius, yRadius: radius)
        let startSliderPath = NSBezierPath(roundedRect: startSliderFrame, xRadius: 2.0, yRadius: 2.0)
        let endSliderPath = NSBezierPath(roundedRect: endSliderFrame, xRadius: 2.0, yRadius: 2.0)
        
        barBackgroundGradient.draw(in: framePath, angle: -verticalGradientDegrees)
        
        if NSWidth(selectedRect) > 0.0 {
            barFillGradient.draw(in: selectedPath, angle: verticalGradientDegrees)
            barFillStrokeColor.setStroke()
            selectedPath.stroke()
        }
        
        barStrokeColor.setStroke()
        framePath.stroke()
        
        let shadow = NSShadow()
        shadow.shadowOffset = NSSize(width: 2.0, height: -2.0)
        shadow.shadowBlurRadius = 2.0
        shadow.shadowColor = NSColor(white: 0.0, alpha: 0.1)
        
        NSGraphicsContext.saveGraphicsState()
        shadow.set()
        
        startSliderPath.fill()
        endSliderPath.fill()
        NSGraphicsContext.restoreGraphicsState()
        
        sliderGradient.draw(in: startSliderPath, angle: verticalGradientDegrees)
        startSliderPath.stroke()
        
        sliderGradient.draw(in: endSliderPath, angle: verticalGradientDegrees)
        endSliderPath.stroke()
    }
}
