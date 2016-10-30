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
let barTrailingMargin: CGFloat = 1.0

struct SelectionRange {
    var start: Double
    var end: Double
}

enum DraggedSlider {
    case start
    case end
}

enum RangeSliderColorStyle {
    case yellow
    case aqua
}

class RangeSlider: NSView {
    
    //****************************************************************************//
    //****************************************************************************//
    /*
        RangeSlider is a general-purpose macOS control which is similar to NSSlider
        except that it allows for the selection of a span or range (it has two control
        points, a start and end, which can both be adjusted).
    */
    //****************************************************************************//
    //****************************************************************************//
    
    //MARK: - Basic Usage -
    
    /** The start of the selected span in the slider. */
    var start: Double {
        get {
            return (selection.start * (maxValue - minValue)) + minValue
        }
        
        set {
            selection = SelectionRange(start: newValue, end: selection.end)
            setNeedsDisplay(bounds)
        }
    }
    
    /** The end of the selected span in the slider. */
    var end: Double {
        get {
            return (selection.end * (maxValue - minValue)) + minValue
        }
        
        set {
            selection = SelectionRange(start: selection.start, end: newValue)
            setNeedsDisplay(bounds)
        }
    }
    
    /** The length of the selected span. Note that by default
        this length is inclusive when snapsToIntegers is true,
        which will be the expected/desired behavior in most such
        configurations. In scenarios where it may be weird to have
        a length of 1.0 when the start and end slider are at an
        identical value, you can disable this by setting
        inclusiveLengthForSnapTo to false. */
    var length: Double {
        get {
            let fractionalLength = (selection.end - selection.start)

            return (fractionalLength * (maxValue - minValue)) + (snapsToIntegers && inclusiveLengthForSnapTo ? 1.0 : 0.0)
        }
    }
    
    /** The minimum value of the slider. */
    var minValue: Double = 0.0
    
    /** The maximum value of the slider. */
    var maxValue: Double = 1.0
    
    /** Defaults is false (off). If set to true, the slider
        will snap to whole integer values for both sliders. */
    var snapsToIntegers: Bool = false
    
    /** Defaults to true, and makes the length property
        inclusive when snapsToIntegers is enabled. */
    var inclusiveLengthForSnapTo: Bool = true
    
    /** Defaults to true, allows clicks off of the slider knobs
        to reposition the bars. */
    var allowClicksOnBarToMoveSliders: Bool = true
    
    /** The color style of the slider. */
    var colorStyle: RangeSliderColorStyle = .yellow {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    //****************************************************************************//
    //****************************************************************************//
    
    //MARK: - Properties -
    
    var selection: SelectionRange = SelectionRange(start: 0.0, end: 1.0) {
        willSet {
            if newValue.start != selection.start {
                self.willChangeValue(forKey: "start")
            }
            
            if newValue.end != selection.end {
                self.willChangeValue(forKey: "end")
            }
            
            if (newValue.end - newValue.start) != (selection.end - selection.start) {
                self.willChangeValue(forKey: "length")
            }
        }
        
        didSet {
            if oldValue.start != selection.start {
                self.didChangeValue(forKey: "start")
            }
            
            if oldValue.end != selection.end {
                self.didChangeValue(forKey: "end")
            }
            
            if (oldValue.end - oldValue.start) != (selection.end - selection.start) {
                self.didChangeValue(forKey: "length")
            }
        }
    }

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
            
            var fillStart: NSColor? = nil
            var fillEnd: NSColor? = nil
            
            if colorStyle == .yellow {
                fillStart = NSColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
                fillEnd = NSColor(red: 1.0, green: 196/255.0, blue: 0.0, alpha: 1.0)
            } else {
                fillStart = NSColor(red: 76/255.0, green: 187/255.0, blue: 251/255.0, alpha: 1.0)
                fillEnd = NSColor(red: 20/255.0, green: 133/255.0, blue: 243/255.0, alpha: 1.0)
            }
            
            let barFillGradient = NSGradient(starting: fillStart!, ending: fillEnd!)
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
            if colorStyle == .yellow {
                return NSColor(red: 1.0, green: 170/255.0, blue: 16/255.0, alpha: 0.70)
            } else {
                return NSColor(red: 12/255.0, green: 118/255.0, blue: 227/255.0, alpha: 0.70)
            }
        }
    }
    
    let sliderWidth = CGFloat(8.0)
    
    var sliderHeight: CGFloat {
        get {
            return NSHeight(bounds) - verticalShadowPadding
        }
    }
    
    var minSliderX: CGFloat {
        get {
            return 0.0
        }
    }
    
    var maxSliderX: CGFloat {
        get {
            return NSWidth(bounds) - sliderWidth - barTrailingMargin
        }
    }
    
    //MARK: - Event -
    
    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        let startSlider = frameForStartSlider()
        let endSlider = frameForEndSlider()
        
        if NSPointInRect(point, startSlider) {
            currentSliderDragging = .start
        } else if NSPointInRect(point, endSlider) {
            currentSliderDragging = .end
        } else {
            if allowClicksOnBarToMoveSliders {
                let startDist = abs(NSMidX(startSlider) - point.x)
                let endDist = abs(NSMidX(endSlider) - point.x)
                
                if (startDist < endDist) {
                    currentSliderDragging = .start
                } else {
                    currentSliderDragging = .end
                }
                
                updateForClick(atPoint: point)
            } else {
                currentSliderDragging = nil
            }
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        updateForClick(atPoint: point)
    }
    
    func updateForClick(atPoint point: NSPoint) {
        if currentSliderDragging != nil {
            var x = Double(point.x / NSWidth(bounds))
            x = max(min(1.0, x), 0.0)
            
            if snapsToIntegers {
                let steps = maxValue - minValue
                x = round(x * steps) / steps
            }
            
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
        /*  Floor the rect values here, rather than use NSIntegralRect etc. */
        var newRect = NSMakeRect(floor(rect.origin.x),
                                 floor(rect.origin.y),
                                 floor(rect.size.width),
                                 floor(rect.size.height))
        newRect.origin.x += 0.5
        newRect.origin.y += 0.5
        
        return newRect
    }
    
    func frameForStartSlider() -> NSRect {
        var x = max(CGFloat(selection.start) * NSWidth(bounds) - (sliderWidth / 2.0), minSliderX)
        x = min(x, maxSliderX)
        
        return crispLineRect(NSMakeRect(x, (NSHeight(bounds) - sliderHeight) / 2.0, sliderWidth, sliderHeight))
    }
    
    func frameForEndSlider() -> NSRect {
        let width = NSWidth(bounds)
        var x = CGFloat(selection.end) * width
        x -= (sliderWidth / 2.0)
        x = min(x, maxSliderX)
        x = max(x, minSliderX)
        
        return crispLineRect(NSMakeRect(x, (NSHeight(bounds) - sliderHeight) / 2.0, sliderWidth, sliderHeight))
    }
    
    //MARK: - Layout
    
    override func layout() {
        super.layout()
        
        assert(NSWidth(bounds) >= (NSHeight(bounds) * 2), "Range control expects a reasonable width to height ratio, width should be greater than twice the height at least.");
        assert(NSWidth(bounds) >= (sliderWidth * 2.0), "Width must be able to accommodate two range sliders.")
        assert(NSHeight(bounds) >= sliderHeight, "Expects minimum height of at least \(sliderHeight)")
    }
    
    //MARK: - Drawing -
    
    override func draw(_ dirtyRect: NSRect) {
        let width = NSWidth(bounds) - barTrailingMargin
        let height = NSHeight(bounds)
        
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
        shadow.shadowColor = NSColor(white: 0.0, alpha: 0.12)
        
        NSGraphicsContext.saveGraphicsState()
        shadow.set()
        
        startSliderPath.fill()
        endSliderPath.fill()
        NSGraphicsContext.restoreGraphicsState()
        
        sliderGradient.draw(in: endSliderPath, angle: verticalGradientDegrees)
        endSliderPath.stroke()
        
        sliderGradient.draw(in: startSliderPath, angle: verticalGradientDegrees)
        startSliderPath.stroke()
    }
}
