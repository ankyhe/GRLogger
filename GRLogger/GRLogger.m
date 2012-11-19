//
//  GRLogger.h
//  GRLogger
//
//  Created by AnkyHe, gerystudio@gmail.com on 12-5-28.
//  Copyright (c) 2012 Gery Studio. All rights reserved.
//

#import <pthread.h> // for pthread_rwlock_t
#import "GRLogger.h"

/* Failure process for pthread rwlock lock/unlock */
static int const kPTHREAD_RELATED_EXIT = 234;
#define GRLOGGER_EXIT(x) while(0){exit(x);} // do nothing
/* END */

static BOOL gLoggerHasBeenDealloc = NO;
static GRLogger *gLogger = nil;

static NSString * threadName()
{
    return (dispatch_get_current_queue() == dispatch_get_main_queue() ?  @"Main " : @"Other");

}

static NSString * outputLevelName(GROutputLevel outputLevel) {
	switch (outputLevel) {
		case GROutputLevelTiny:    return @"TINY";break;
		case GROutputLevelDetail:  return @"DETAIL";break;
		case GROutputLevelEnter:   return @"ENTER";break;
		case GROutputLevelReturn:  return @"RETURN";break;
		case GROutputLevelInfo:    return @"INFO";break;
		case GROutputLevelDebug:   return @"DEBUG";break;
		case GROutputLevelWarning: return @"WARN";break;
		case GROutputLevelError:   return @"ERROR";break;
        case GROutputLevelTrace0:  return @"TRACE0";break;
		case GROutputLevelFatal:   return @"FATAL";break;
		default:                   return @"NOLEVE"; break;
	}
}

@implementation GRLogger {
    pthread_rwlock_t _logLevelRWLock;
}

@synthesize loggerLevel = _loggerLevel;

#pragma mark - Singleton
+ (GRLogger *)sharedGRLogger
{
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        gLogger = [[super allocWithZone:NULL]init];
    });
    return gLogger;
}

+ (id)allocWithZone:(NSZone *)zone
{
#if !__has_feature(objc_arc)
    return [[self sharedGRLogger] retain];
#else
    return [self sharedGRLogger];
#endif
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#if ! __has_feature(objc_arc)
- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release {}

- (id)autorelease {
    return self;
}
#endif

#pragma mark - Method init
- (id)initWithLoggerLevel:(GRLoggerLevel)loggerLevel
{
	if ((self = [super init])) {
        _loggerLevel = loggerLevel;
        if (pthread_rwlock_init(&_logLevelRWLock, NULL)) {
            // error
            NSLog(@"Fail to init rwlock in GRLogger");
            GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
        }
	}
	return self;
}

- (id)init
{
	return [self initWithLoggerLevel:GRLoggerLevelDefault];
}


- (void)dealloc
{
    if (pthread_rwlock_destroy(&_logLevelRWLock)) {
        // error
        NSLog(@"Fail to destroy rwlock in GRLogger");
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    gLogger = nil;
    gLoggerHasBeenDealloc = YES;
}

- (GRLoggerLevel)loggerLevel
{
    GRLoggerLevel ret = GRLoggerLevelDefault;
    if(pthread_rwlock_rdlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
    ret = _loggerLevel;
    if (pthread_rwlock_unlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
    return ret;
}

- (void)setLoggerLevel:(GRLoggerLevel)loggerLevel
{
    if (pthread_rwlock_wrlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
    if (loggerLevel == GRLoggerLevelAll || loggerLevel == GRLoggerLevelMajor ||
        loggerLevel == GRLoggerLevelMinor ||
        loggerLevel == GRLoggerLevelNone || loggerLevel == GRLoggerLevelDefault) {
        _loggerLevel = loggerLevel;
    } else {
        _loggerLevel = GRLoggerLevelDefault;
    }
    if (pthread_rwlock_unlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
}

- (void)resetLoggerLevel
{
    [self setLoggerLevel:GRLoggerLevelDefault];
}

#pragma mark - Member Methods
- (void)log:(NSString *)msg
  withLevel:(GROutputLevel)level
     inFile:(NSString *)fileName
     inLine:(int)lineNumber
{

    if ((NSUInteger)level > (NSUInteger)self.loggerLevel)	{
		NSLog(@"TID:%@ FILE:%@ LINE:%04d [%@] %@", threadName(), fileName, lineNumber,
              outputLevelName(level), msg);
	}
}

- (void)enter:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:GROutputLevelEnter inFile:fileName inLine:lineNumber];
}

- (void)retrn:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:GROutputLevelReturn inFile:fileName inLine:lineNumber];
}

- (void)debug:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:GROutputLevelDebug inFile:fileName inLine:lineNumber];
}

- (void)info:(NSString *)msg
      inFile:(NSString *)fileName
      inLine:(int)lineNumber
{
	[self log:msg withLevel:GROutputLevelInfo inFile:fileName inLine:lineNumber];
}

- (void)warn:(NSString *)msg
      inFile:(NSString *)fileName
      inLine:(int)lineNumber
{
	[self log:msg withLevel:GROutputLevelWarning inFile:fileName inLine:lineNumber];
}

- (void)error:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:GROutputLevelError inFile:fileName inLine:lineNumber];
}

- (void)trace0:(NSString *)msg
        inFile:(NSString *)fileName
        inLine:(int)lineNumber
{
    [self log:msg withLevel:GROutputLevelTrace0 inFile:fileName inLine:lineNumber];
}

- (void)fatal:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:GROutputLevelFatal inFile:fileName inLine:lineNumber];
}

@end
