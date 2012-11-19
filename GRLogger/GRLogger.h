//
//  GRLogger.h
//  GRLogger
//
//  Created by AnkyHe, gerystudio@gmail.com on 12-5-28.
//  Copyright (c) 2012 Gery Studio. All rights reserved.
//


#import <Foundation/Foundation.h>

#ifndef __SELF_DEFING_CLOSEGRLOGGER__

#define LOG(level, format, ...) [[GRLogger sharedGRLogger] log:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
withLevel:level \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define ENTERFUNC() [[GRLogger sharedGRLogger] enter:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define ENTER(format, ...) [[GRLogger sharedGRLogger] enter:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define RETURNFUNC(returnValue) [[GRLogger sharedGRLogger] retrn:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]; return (returnValue)
#define RETURN(returnValue, format, ...) [[GRLogger sharedGRLogger] retrn:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]; return (returnValue)

#define INFO(format, ...) [[GRLogger sharedGRLogger] info:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define DBG(format, ...) [[GRLogger sharedGRLogger] debug:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define WARN(format, ...) [[GRLogger sharedGRLogger] warn:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define ERROR(format, ...) [[GRLogger sharedGRLogger] error:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define TRACE0(format, ...) [[GRLogger sharedGRLogger] trace0:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define FATAL(format, ...) [[GRLogger sharedGRLogger] fatal:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define SETLOGLEVEL(level) [[GRLogger sharedGRLogger] setLoggerLevel: level]

#else // defined __SELF_DEFING_CLOSEGRLOGGER__
#define LOG(level, format, ...) while(0) {[[GRLogger sharedGRLogger] log:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
withLevel:level \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define ENTERFUNC() while(0) {[[GRLogger sharedGRLogger] enter:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define ENTER(format, ...)      while(0) {[[GRLogger sharedGRLogger] enter:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define RETURNFUNC(returnValue) while(0) {[[GRLogger sharedGRLogger] retrn:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];} return (returnValue)
#define RETURN(returnValue, format, ...) while(0) {[[GRLogger sharedGRLogger] retrn:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}return (returnValue)
#define INFO(format, ...)  while(0) {[[GRLogger sharedGRLogger] info:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define DBG(format, ...)   while(0) {[[GRLogger sharedGRLogger] debug:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define WARN(format, ...)  while(0) {[[GRLogger sharedGRLogger] warn:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define ERROR(format, ...) while(0) {[[GRLogger sharedGRLogger] error:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define TRACE0(format, ...) while(0) {[[GRLogger sharedGRLogger] trace0:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define FATAL(format, ...) while(0) {[[GRLogger sharedGRLogger] fatal:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define SETLOGLEVEL(level) while(0) {[[GRLogger sharedGRLogger] setLoggerLevel: level];}

#endif // __SELF_DEFING_CLOSEGRLOGGER__

/*!
 @enum GROutputLevel
 */
typedef enum GROutputLevel : NSUInteger {
	GROutputLevelTiny    = 10,
	GROutputLevelDetail  = 20,
	GROutputLevelEnter   = 30,
	GROutputLevelReturn  = 31,
	GROutputLevelDebug   = 40,
	GROutputLevelInfo    = 50,
	GROutputLevelWarning = 60,
	GROutputLevelError   = 70,
    GROutputLevelTrace0  = 75,
	GROutputLevelFatal   = 80
} GROutputLevel;

/*!
   @enum GRLoggerLevel
 */
typedef enum GRLoggerLevel : NSUInteger {
	GRLoggerLevelAll     = 0,
	GRLoggerLevelMajor   = 45,
    GRLoggerLevelMinor   = 65,
	GRLoggerLevelNone    = 1000,
    GRLoggerLevelDefault = GRLoggerLevelMajor
} GRLoggerLevel;

/*!
   GRLogger is logger class for logging in iOS
 */
@interface GRLogger : NSObject

/*!
   loggerLevel denotes logging level
 */
@property (atomic, assign) GRLoggerLevel loggerLevel;

/*!
   @function sharedGRLogger returns a singleton instance
   @return a singleton GRLogger instance
 */
+ (GRLogger *)sharedGRLogger;


- (void)log:(NSString *)msg
  withLevel:(GROutputLevel)level
     inFile:(NSString *)fileName
     inLine:(int)lineNumber;

- (void)enter:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber;
- (void)retrn:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber;
- (void)debug:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber;
- (void)info:(NSString *)msg
      inFile:(NSString *)fileName
      inLine:(int)lineNumber;
- (void)warn:(NSString *)msg
      inFile:(NSString *)fileName
      inLine:(int)lineNumber;
- (void)error:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber;
- (void)trace0:(NSString *)msg
        inFile:(NSString *)fileName
        inLine:(int)lineNumber;
- (void)fatal:(NSString *)msg
       inFile:(NSString *)fileName
       inLine:(int)lineNumber;


@end
