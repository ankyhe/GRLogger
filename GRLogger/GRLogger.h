/**
 *  \file		  GRLogger.h
 *  \brief		GRLogger is used to logger information into console easily
 *  \author		AnkyHe ankyhe@gmail.com
 *  \version  1.0
 *  \date     2012/05/28
 */

#import <Foundation/Foundation.h>
#import <pthread.h>

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
#define SETLOGLEVEL(level) [[GRLogger sharedGRLogger] setLogLevelSetting: level] 

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
#define SETLOGLEVEL(level) while(0) {[[GRLogger sharedGRLogger] setLogLevelSetting: level];}

#endif // __SELF_DEFING_CLOSEGRLOGGER__

typedef enum {
	kSLL_TINY    = 10,
	kSLL_DETAIL  = 20,
	kSLL_ENTER   = 30,
	kSLL_RETURN  = 31,
	kSLL_DEBUG   = 40,
	kSLL_INFO    = 50,
	kSLL_WARNING = 60,
	kSLL_ERROR   = 70,
  kSLL_TRACE0  = 75,
	kSLL_FATAL   = 80
} GRLoggerLevel;

typedef enum {
	kSLLS_ALL = 0, // should be smaller than all GRLoggerLevel	
	kSLLS_MAJOR = 45, // should be larger than SLL_DEBUG
  kSLLS_MINOR = 65,
	kSLLS_NONE = 1000, // should be larger than all
  kSLLS_DEFAULT = kSLLS_MAJOR // SLLS_DEFAULT = SLLS_MAJOR
} GRLoggerLevelSetting;

@interface GRLogger : NSObject {
 @private
	GRLoggerLevelSetting logLevelSetting_;
  pthread_rwlock_t logLevelRWLock_;
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
- (void)trace0:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber;
- (void)fatal:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber;

+ (GRLogger *)sharedGRLogger;
+ (NSString *)levelName:(GRLoggerLevel)level;

@end
