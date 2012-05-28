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

int foo()
{
  ENTER(@"foo");
  RETURN(10, @"foo");
}

int main(int argc, char *argv[])
{
  @autoreleasepool {
    SETLOGLEVEL(SLLS_ALL);
    INFO(@"info");
    DBG(@"debug value is %d", 3);
    WARN(@"warning");
    ERROR(@"error");
    FATAL(@"fatal");
    LOG(SLL_TINY, @"tiny");
    foo();
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
