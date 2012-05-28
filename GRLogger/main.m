//
//  main.m
//  GRLogger
//
//  Created by He Anky on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import "GRLogger.h"

int main(int argc, char *argv[])
{
  @autoreleasepool {
    INFO(@"here %d", 3);
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
