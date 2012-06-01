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
		case SLL_TINY:    return @"TINY";break;
		case SLL_DETAIL:  return @"DETAIL";break;
		case SLL_ENTER:   return @"ENTER";break;
		case SLL_RETURN:  return @"RETURN";break;
		case SLL_INFO:    return @"INFO";break;
		case SLL_DEBUG:   return @"DEBUG";break;
		case SLL_WARNING: return @"WARN";break;
		case SLL_ERROR:   return @"ERROR";break;
    case SLL_TRACE0:  return @"TRACE0";break;
		case SLL_FATAL:   return @"FATAL";break;
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
	return [self initWithLogLevel:SLLS_DEFAULT];
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
  GRLoggerLevelSetting ret = SLLS_DEFAULT;
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
  if (logLevelSetting == SLLS_ALL || logLevelSetting == SLLS_MINOR ||
      logLevelSetting == SLLS_MAJOR ||
      logLevelSetting == SLLS_NONE || logLevelSetting == SLLS_DEFAULT) {
    logLevelSetting_ = logLevelSetting; 
  } else {
    logLevelSetting_ = SLLS_DEFAULT;
  }
  if (pthread_rwlock_unlock(&logLevelRWLock_)) {
    GRLOGGER_EXIT(kPTHREAD_RELATED_EXIT);
  }
}

- (void)resetLogLevelSetting 
{
  [self setLogLevelSetting:SLLS_DEFAULT];
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
	[self log:msg withLevel:SLL_ENTER inFile:fileName inLine:lineNumber];
}

- (void)retrn:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber
{
	[self log:msg withLevel:SLL_RETURN inFile:fileName inLine:lineNumber];
}

- (void)info:(NSString *)msg 
      inFile:(NSString *)fileName 
      inLine:(int)lineNumber
{
	[self log:msg withLevel:SLL_INFO inFile:fileName inLine:lineNumber];
}

- (void)debug:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber
{
	[self log:msg withLevel:SLL_DEBUG inFile:fileName inLine:lineNumber];
}

- (void)warn:(NSString *)msg 
      inFile:(NSString *)fileName 
      inLine:(int)lineNumber
{
	[self log:msg withLevel:SLL_WARNING inFile:fileName inLine:lineNumber];
}

- (void)error:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber
{
	[self log:msg withLevel:SLL_ERROR inFile:fileName inLine:lineNumber];
}

- (void)trace0:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber
{
  [self log:msg withLevel:SLL_TRACE0 inFile:fileName inLine:lineNumber];   
}

- (void)fatal:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNumber
{
	[self log:msg withLevel:SLL_FATAL inFile:fileName inLine:lineNumber];
}

@end
