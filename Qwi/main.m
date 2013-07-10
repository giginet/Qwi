//
//  main.m
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UI7Kit.h"

#import "QWAppDelegate.h"

int main(int argc, char *argv[]) {
    @autoreleasepool {
        [UI7Kit patchIfNeeded];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QWAppDelegate class]));
    }
}
