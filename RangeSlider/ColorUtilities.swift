//
//  ColorUtilities.swift
//  RangeSlider
//
//  Created by Matt Reagan on 3/18/17.
//  Copyright © 2017 Matt Reagan. All rights reserved.
//

import Cocoa

extension NSColor {
    func colorByDesaturating(_ desaturationRatio: CGFloat) -> NSColor {
        return NSColor(hue: self.hueComponent,
                       saturation: self.saturationComponent * desaturationRatio,
                       brightness: self.brightnessComponent,
                       alpha: self.alphaComponent);
    }
}
