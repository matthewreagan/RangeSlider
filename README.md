# RangeSlider

![Styles](/RangeSliderStyles.png?raw=true "Styles")

**RangeSlider** is a clean, simple, and attractive range-based slider control for Mac, written in [Swift](https://developer.apple.com/swift/).

It is similar to [NSSlider](https://developer.apple.com/reference/appkit/nsslider) except that it affords two control points (start and end knobs), useful when users need to select a range of values.

**Features**:

- Simple, easy-to-use
- Flexible resizing
- Customizable
- Snap-to-interval (optional)
- Several built-in styles

## Demo

![RangeSlider Demo](/RangeSliderDemo.gif?raw=true "RangeSlider Demo")

## How To Use

1. Add to XIB or create programmatically. Example: `let slider = RangeSlider(frame:sliderFrame)`
2. _(Optional)_ Set the min/max values (default: `0.0-1.0`)
3. _(Optional)_ Set the `start`/`end` values (default: `0.0-1.0`)
4. _(Optional)_ Enable snapping (`snapsToIntegers = true`)
5. _(Optional)_ Adjust style options (`colorStyle`, `knobStyle`)

## Responding to Changes

Once the slider is configured, you can respond to changes by observing the `start`/`end` (or `length`) values, or using the `onControlChanged` property.

Example:
```
mySlider.onControlChanged = {
    (slider: RangeSlider) -> Void in
    print("Slider changed! Start:\(slider.start) End:\(slider.end) Range:\(slider.length)")
}
```

## ToDo's

RangeSlider is still a work-in-progress. A few of the known issues / ToDo's remaining:

- [ ] Fix clipping of knob shadows, especially for circular slider style
- [ ] General cleanup, refactoring (fix computed `NSGradient` properties etc.)
- [ ] Fix knobs being allowed to overlap
- [ ] Improve border stroke of circular knob style

## System Requirements

RangeSlider is currently macOS-only, however it could easily be updated to work with UIKit. Please file an Issue or feel free to submit a Pull Request if you'd like iOS support.

## Author

**Matt Reagan** - Website: [http://sound-of-silence.com/](http://sound-of-silence.com/) - Twitter: [@hmblebee](https://twitter.com/hmblebee)


## License

RangeSlider's source code and related resources are Copyright (C) Matthew Reagan 2016. The source code is released under the [MIT License](https://opensource.org/licenses/MIT). If you use RangeSlider in any publicly-distributed applications please include attribution. 
