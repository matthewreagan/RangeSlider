//
//  Demo.swift
//  RangeSlider
//
//  Created by Matt Reagan on 10/29/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

import Foundation
import Cocoa

class Demo: NSObject {
    @IBOutlet weak var slider1Label1: NSTextField!
    @IBOutlet weak var slider1Label2: NSTextField!
    @IBOutlet weak var slider1Label3: NSTextField!
    @IBOutlet weak var slider2Label1: NSTextField!
    @IBOutlet weak var slider2Label2: NSTextField!
    @IBOutlet weak var slider2Label3: NSTextField!
    @IBOutlet weak var slider3Label1: NSTextField!
    @IBOutlet weak var slider3Label2: NSTextField!
    @IBOutlet weak var slider3Label3: NSTextField!
    @IBOutlet weak var slider4Label1: NSTextField!
    @IBOutlet weak var slider4Label2: NSTextField!
    @IBOutlet weak var slider4Label3: NSTextField!
    @IBOutlet weak var slider1: RangeSlider!
    @IBOutlet weak var slider2: RangeSlider!
    @IBOutlet weak var slider3: RangeSlider!
    @IBOutlet weak var slider4: RangeSlider!
    @IBOutlet weak var slider4InclusiveCheckbox: NSButton!
    
    override func awakeFromNib() {
        
        //********** Slider Demo ************//
        
        slider1.start = 0.25
        slider1.end = 0.75
        slider2.start = 0.5
        slider3.start = 0.2
        
        slider4.snapsToIntegers = true
        slider4.minValue = 1
        slider4.maxValue = 10
        
        slider1Label1.bind("doubleValue", to: slider1, withKeyPath: "start", options: nil)
        slider1Label2.bind("doubleValue", to: slider1, withKeyPath: "end", options: nil)
        slider1Label3.bind("doubleValue", to: slider1, withKeyPath: "length", options: nil)
        
        slider2Label1.bind("doubleValue", to: slider2, withKeyPath: "start", options: nil)
        slider2Label2.bind("doubleValue", to: slider2, withKeyPath: "end", options: nil)
        slider2Label3.bind("doubleValue", to: slider2, withKeyPath: "length", options: nil)
        
        slider3Label1.bind("doubleValue", to: slider3, withKeyPath: "start", options: nil)
        slider3Label2.bind("doubleValue", to: slider3, withKeyPath: "end", options: nil)
        slider3Label3.bind("doubleValue", to: slider3, withKeyPath: "length", options: nil)
        
        slider4Label1.bind("integerValue", to: slider4, withKeyPath: "start", options: nil)
        slider4Label2.bind("integerValue", to: slider4, withKeyPath: "end", options: nil)
        slider4Label3.bind("integerValue", to: slider4, withKeyPath: "length", options: nil)
    }
    
    @IBAction func inclusiveCheckboxClicked(_ sender: AnyObject) {
        slider4.inclusiveLengthForSnapTo = ((sender as! NSButton).state == NSOnState)
    }
}
