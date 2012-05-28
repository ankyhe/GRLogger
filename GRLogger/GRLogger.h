/**
 *  \file		  GRLogger.h
 *  \brief		GRLogger is used to logger information into console easily
 *  \author		AnkyHe ankyhe@gmail.com
 *  \version  1.0
 *  \date     2012/05/28
 */

#import <Foundation/Foundation.h>

#ifndef __SELF_DEFING_CLOSEGRLOGGER__

#define LOG(level, format, ...) [[GRLogger sharedGRLogger] log:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
withLevel:level \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define ENTER(format, ...) [[GRLogger sharedGRLogger] enter:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
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
#define FATAL(format, ...) [[GRLogger sharedGRLogger] fatal:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__]
#define SETLOGLEVEL(level) [[GRLogger sharedGRLogger] setLogLevelSetting: level] 

#else // defined __SELF_DEFING_CLOSEGRLOGGER__
#define LOG(level, format, ...) while(0) {[[GRLogger sharedGRLogger] log:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
withLevel:level \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define ENTER(format, ...)      while(0) {[[GRLogger sharedGRLogger] enter:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
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
#define FATAL(format, ...) while(0) {[[GRLogger sharedGRLogger] fatal:[NSString stringWithFormat:(format), ##__VA_ARGS__] \
inFile:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] \
inLine:__LINE__];}
#define SETLOGLEVEL(level) while(0) {[[GRLogger sharedGRLogger] setLogLevelSetting: level];}

#endif // __SELF_DEFING_CLOSEGRLOGGER__

typedef enum {
	SLL_TINY    = 10,
	SLL_DETAIL  = 20,
	SLL_ENTER   = 30,
	SLL_RETURN  = 31,
	SLL_DEBUG   = 40,
	SLL_INFO    = 50,
	SLL_WARNING = 60,
	SLL_ERROR   = 70,
	SLL_FATAL   = 80
} GRLoggerLevel;

typedef enum {
	SLLS_ALL = 0, // should be smaller than all GRLoggerLevel
	SLLS_MINOR = 21, // should be larger than SLL_DETAIL
	SLLS_MEDIUM = 35, // should be larger than SLL_RETURN
	SLLS_MAJOR = 45, // should be larger than SLL_DEBUG
	SLLS_NONE = 1000, // should be larger than all
  SLLS_DEFAULT = SLLS_MAJOR // SLLS_DEFAULT = SLLS_MAJOR
} GRLoggerLevelSetting;

@interface GRLogger : NSObject {
 @private
	GRLoggerLevelSetting logLevelSetting_;
}

@property (atomic, assign) GRLoggerLevelSetting logLevelSetting;


- (void)log:(NSString *)msg 
  withLevel:(GRLoggerLevel)level
     inFile:(NSString *)fileName 
     inLine:(int)lineNumber;

- (void)enter:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber;
- (void)retrn:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber;
- (void)info:(NSString *)msg 
      inFile:(NSString *)fileName 
      inLine:(int)lineNumber;
- (void)debug:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber;
- (void)warn:(NSString *)msg 
      inFile:(NSString *)fileName 
      inLine:(int)lineNumber;
- (void)error:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber;
- (void)fatal:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber;

+ (GRLogger *)sharedGRLogger;
+ (NSString *)levelName:(GRLoggerLevel)level;

@end
