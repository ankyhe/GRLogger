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

@interface TestClass : NSObject
- (int)bar;
@end

@implementation TestClass

- (int)bar 
{
  ENTERFUNC();
  RETURNFUNC(10);
}

@end

int foo()
{
  ENTERFUNC();
  RETURNFUNC(10);
}

int main(int argc, char *argv[])
{
  @autoreleasepool {
    SETLOGLEVEL(kSLLS_ALL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
      foo();
    });
    SETLOGLEVEL(kSLLS_ALL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
      TestClass *tc = [[TestClass alloc]init];
      int ret = [tc bar];
      INFO(@"[tc bar] returns %d", ret);
    });
    INFO(@"info");
    DBG(@"debug value is %d", 3);
    WARN(@"warning");
    ERROR(@"error");
    FATAL(@"fatal");
    LOG(kSLL_TINY, @"tiny");
    TRACE0(@"Ready to start");
    
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
  }
}
