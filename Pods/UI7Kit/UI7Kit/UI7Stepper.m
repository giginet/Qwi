//
//  UI7Stepper.m
//  UI7Kit
//
//  Created by Jeong YunWon on 13. 6. 18..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UI7View.h"

#import "UI7Stepper.h"

#import "UI7KitPrivate.h"

@interface UIView ()

- (UIColor *)_view_tintColor;

@end


@implementation UIStepper (Patch)

- (void)awakeFromNib { [super awakeFromNib]; }

- (id)__init { assert(NO); return nil; }
- (void)__awakeFromNib { assert(NO); }

- (void)_stepperInit {
    self.layer.cornerRadius = UI7ControlRadius;
    self.layer.borderWidth = 1.0f;
    [self _tintColorUpdated];
}

- (void)_tintColorUpdated {
    [super _tintColorUpdated];

    if ([self respondsToSelector:@selector(setBackgroundImage:forState:)]) {
        NSDictionary *backColors = @{
                                     @(UIControlStateNormal): [UIColor clearColor],
                                     @(UIControlStateHighlighted): self.tintColor.highligtedColor,
                                     @(UIControlStateDisabled): [UIColor clearColor],
                                     };
        NSDictionary *titleColors = @{
                                      @(UIControlStateNormal): self.tintColor,
                                      @(UIControlStateHighlighted): self.tintColor.highligtedColor,
                                      @(UIControlStateDisabled): self.tintColor.highligtedColor,
                                      };

        [self setDividerImage:self.tintColor.image forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];

        for (NSNumber *stateNumber in @[@(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateDisabled)]) {
            UIControlState state = (UIControlState)(stateNumber.integerValue);
            UIImage *backgroundImage = [UIImage roundedImageWithSize:CGSizeMake(10.0, 30.0) color:backColors[stateNumber] radius:UI7ControlRadius];
            [self setBackgroundImage:backgroundImage forState:state];
            UIImage *image;
            image = [self incrementImageForState:state];
            if (image) {
                [self setIncrementImage:[image imageByFilledWithColor:titleColors[stateNumber]] forState:state];
            }
            image = [self decrementImageForState:state];
            if (image) {
                [self setDecrementImage:[image imageByFilledWithColor:titleColors[stateNumber]] forState:state];
            }
        }
    } else {
        // iOS5
        //        for (CALayer *layer in self.layer.sublayers.reverseObjectEnumerator) {
        //            [layer removeFromSuperlayer];
        //            static int count = 0;
        //            count += 1;
        //            if (count ==3) break;
        //        }
    }

    self.layer.borderColor = self.tintColor.CGColor;
}

@end

@implementation UI7Stepper

+ (void)initialize {
    if (self == [UI7Stepper class]) {
        Class target = [UIStepper class];

        [target copyToSelector:@selector(__init) fromSelector:@selector(initWithItems:)];
        [target copyToSelector:@selector(__awakeFromNib) fromSelector:@selector(awakeFromNib)];

        NSAMethod *tintColorMethod = [target methodForSelector:@selector(tintColor)];
        NSAMethod *viewTintColorMethod = [target methodForSelector:@selector(_view_tintColor)];
        if (tintColorMethod.implementation != viewTintColorMethod.implementation) {
            [target methodForSelector:@selector(__tintColor)].implementation = tintColorMethod.implementation;
        } else {
            [target addMethodForSelector:@selector(tintColor) fromMethod:[target methodForSelector:@selector(__tintColor)]];
        }
    }
}

+ (void)patch {
    Class target = [UIStepper class];

    [self exportSelector:@selector(initWithItems:) toClass:target];
    [self exportSelector:@selector(awakeFromNib) toClass:target];
    [target methodForSelector:@selector(tintColor)].implementation = [target methodForSelector:@selector(_tintColor)].implementation;
}

- (void)awakeFromNib {
    [self __awakeFromNib];
    [self _stepperInit];
}

- (id)init {
    self = [self __init];
    if (self != nil) {
        [self _stepperInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self _stepperInit];
    }
    return self;
}

- (UIColor *)tintColor {
    return [super _tintColor];
}

@end
