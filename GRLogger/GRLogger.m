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

static GRLogger *gLogger = nil;

@interface GRLogger()
- (id)initWithLogLevel:(GRLoggerLevelSetting)levelSetting;
@end

@implementation GRLogger {
    pthread_rwlock_t _logLevelRWLock;
}

@synthesize logLevelSetting = _logLevelSetting;

#pragma mark - Singleton
+ (GRLogger *)sharedGRLogger
{
    static dispatch_once_t once;
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

#pragma mark - Class Methods
+ (NSString *)levelName:(GRLoggerLevel)level {
	switch (level) {
		case kSLL_TINY:    return @"TINY";break;
		case kSLL_DETAIL:  return @"DETAIL";break;
		case kSLL_ENTER:   return @"ENTER";break;
		case kSLL_RETURN:  return @"RETURN";break;
		case kSLL_INFO:    return @"INFO";break;
		case kSLL_DEBUG:   return @"DEBUG";break;
		case kSLL_WARNING: return @"WARN";break;
		case kSLL_ERROR:   return @"ERROR";break;
        case kSLL_TRACE0:  return @"TRACE0";break;
		case kSLL_FATAL:   return @"FATAL";break;
		default:           return @"NOLEVE"; break;
	}
}

#pragma mark - Method init
- (id)initWithLogLevel:(GRLoggerLevelSetting)levelSetting
{
	if ((self = [super init])) {
        _logLevelSetting = levelSetting;
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
	return [self initWithLogLevel:kSLLS_DEFAULT];
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
}

- (GRLoggerLevelSetting)logLevelSetting
{
    GRLoggerLevelSetting ret = kSLLS_DEFAULT;
    if(pthread_rwlock_rdlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
    ret = _logLevelSetting;
    if (pthread_rwlock_unlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
    return ret;
}

- (void)setLogLevelSetting:(GRLoggerLevelSetting)logLevelSetting
{
    if (pthread_rwlock_wrlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
    if (logLevelSetting == kSLLS_ALL || logLevelSetting == kSLLS_MINOR ||
        logLevelSetting == kSLLS_MAJOR ||
        logLevelSetting == kSLLS_NONE || logLevelSetting == kSLLS_DEFAULT) {
        _logLevelSetting = logLevelSetting;
    } else {
        _logLevelSetting = kSLLS_DEFAULT;
    }
    if (pthread_rwlock_unlock(&_logLevelRWLock)) {
        GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
    }
}

- (void)resetLogLevelSetting
{
    [self setLogLevelSetting:kSLLS_DEFAULT];
}

#pragma mark - Member Methods
- (void)log:(NSString *)msg
  withLevel:(GRLoggerLevel)level
     inFile:(NSString *)fileName
     inLine:(int)lineNumber
{
    if ((NSUInteger)level > (NSUInteger)self.logLevelSetting)	{
		NSLog(@"FILE:%@ LINE:%d [%@] %@", fileName, lineNumber,
              [GRLogger levelName:level], msg);
	}
}

- (void)enter:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:kSLL_ENTER inFile:fileName inLine:lineNumber];
}

- (void)retrn:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:kSLL_RETURN inFile:fileName inLine:lineNumber];
}

- (void)info:(NSString *)msg
      inFile:(NSString *)fileName
      inLine:(int)lineNumber
{
	[self log:msg withLevel:kSLL_INFO inFile:fileName inLine:lineNumber];
}

- (void)debug:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:kSLL_DEBUG inFile:fileName inLine:lineNumber];
}

- (void)warn:(NSString *)msg
      inFile:(NSString *)fileName
      inLine:(int)lineNumber
{
	[self log:msg withLevel:kSLL_WARNING inFile:fileName inLine:lineNumber];
}

- (void)error:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:kSLL_ERROR inFile:fileName inLine:lineNumber];
}

- (void)trace0:(NSString *)msg
        inFile:(NSString *)fileName
        inLine:(int)lineNumber
{
    [self log:msg withLevel:kSLL_TRACE0 inFile:fileName inLine:lineNumber];
}

- (void)fatal:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber
{
	[self log:msg withLevel:kSLL_FATAL inFile:fileName inLine:lineNumber];
}

@end
