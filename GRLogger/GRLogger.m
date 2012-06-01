#import "GRLogger.h"


#define GRLOGGER_EXIT exit

static int const kPTHREAD_RELATED_EXIT = 1;

static GRLogger *gLogger = nil;

@interface GRLogger()
- (id)initWithLogLevel:(GRLoggerLevelSetting)levelSetting;
@end

@implementation GRLogger

#pragma -
#pragma mark Singleton

+ (GRLogger *)sharedGRLogger
{
  if (gLogger == nil) {
		@synchronized(self) {
      if (gLogger == nil) {
        gLogger = [[super allocWithZone:NULL]init];
      }
    }
	}
	return gLogger;
}

+ (id)allocWithZone:(NSZone *)zone
{
  return [[self sharedGRLogger] retain];
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

#pragma -
#pragma mark Class Method

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
		default:          return @"NOLEVE"; break;
	}
}

#pragma mark -
#pragma mark Method init

- (id)initWithLogLevel:(GRLoggerLevelSetting)levelSetting
{
	if ((self = [super init])) {
    logLevelSetting_ = levelSetting;
    if (pthread_rwlock_init(&logLevelRWLock_, NULL)) {
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
  if (pthread_rwlock_destroy(&logLevelRWLock_)) {
    // error
    NSLog(@"Fail to destroy rwlock in GRLogger");
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
  }
	[super dealloc];
}



- (GRLoggerLevelSetting)logLevelSetting
{
  GRLoggerLevelSetting ret = kSLLS_DEFAULT;
  if(pthread_rwlock_rdlock(&logLevelRWLock_)) {
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
  }
  ret = logLevelSetting_;
  if (pthread_rwlock_unlock(&logLevelRWLock_)) {
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
  }
  return ret;
}

- (void)setLogLevelSetting:(GRLoggerLevelSetting)logLevelSetting
{
  if (pthread_rwlock_wrlock(&logLevelRWLock_)) {
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
  }
  if (logLevelSetting == kSLLS_ALL || logLevelSetting == kSLLS_MINOR ||
      logLevelSetting == kSLLS_MAJOR ||
      logLevelSetting == kSLLS_NONE || logLevelSetting == kSLLS_DEFAULT) {
    logLevelSetting_ = logLevelSetting; 
  } else {
    logLevelSetting_ = kSLLS_DEFAULT;
  }
  if (pthread_rwlock_unlock(&logLevelRWLock_)) {
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
  }
}

- (void)resetLogLevelSetting 
{
  [self setLogLevelSetting:kSLLS_DEFAULT];
}

#pragma mark -
#pragma mark Method

- (void)log:(NSString *)msg 
  withLevel:(GRLoggerLevel)level
     inFile:(NSString *)fileName 
     inLine:(int)lineNumber
{
  if(pthread_rwlock_rdlock(&logLevelRWLock_)) {
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
  }
	if (level > logLevelSetting_)	{
		NSLog(@"FILE:%@ LINE:%d [%@] %@", fileName, lineNumber,
          [GRLogger levelName:level], msg);
	}
  if (pthread_rwlock_unlock(&logLevelRWLock_)) {
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
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
