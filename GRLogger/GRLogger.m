#import "GRLogger.h"

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
	}
	return self;
}

- (id)init
{
	return [self initWithLogLevel:SLLS_DEFAULT];
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
	[super dealloc];
}
#endif


- (GRLoggerLevelSetting)logLevelSetting
{
  @synchronized(self) {
    return logLevelSetting_;
  }
}

- (void)setLogLevelSetting:(GRLoggerLevelSetting)logLevelSetting
{
  @synchronized(self) {
    if (logLevelSetting == SLLS_ALL || logLevelSetting == SLLS_MINOR ||
        logLevelSetting == SLLS_MAJOR ||
        logLevelSetting == SLLS_NONE || logLevelSetting == SLLS_DEFAULT) {
      logLevelSetting_ = logLevelSetting; 
    } else {
      logLevelSetting_ = SLLS_DEFAULT;
    }
  }
}

- (void)resetLogLevelSetting 
{
  logLevelSetting_ = SLLS_DEFAULT;
}

#pragma mark -
#pragma mark Method

- (void)log:(NSString *)msg 
  withLevel:(GRLoggerLevel)level
     inFile:(NSString *)fileName 
     inLine:(int)lineNumber
{
	if (level > logLevelSetting_)	{
		NSLog(@"FILE:%@ LINE:%d [%@] %@", fileName, lineNumber,
          [GRLogger levelName:level], msg);
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
