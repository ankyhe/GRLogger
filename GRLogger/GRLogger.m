#import "GRLogger.h"

static GRLogger *gLogger = nil;

@interface GRLogger()
- (id)initWithLogLevel:(GRLoggerLevelSetting)levelSetting;
@end

@implementation GRLogger

#pragma -
#pragma mark Class Method

+ (void)initialize 
{
  if (self == [GRLogger class]) {
    [self sharedGRLogger]; // just init GRLogger
  }
}

+ (GRLogger *)sharedGRLogger
{
  if (gLogger == nil) {
		@synchronized(self) {
      if (gLogger == nil) {
        gLogger = [[GRLogger alloc]init];
      }
    }
	}
	return gLogger;
}

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

#ifdef no-objc-arc
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
        logLevelSetting == SLLS_MEDIUM || logLevelSetting == SLLS_MAJOR ||
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
       inLine:(int)lineNr
{
	[self log:msg withLevel:SLL_ENTER inFile:fileName inLine:lineNr];
}

- (void)retrn:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNr
{
	[self log:msg withLevel:SLL_RETURN inFile:fileName inLine:lineNr];
}

- (void)info:(NSString *)msg 
      inFile:(NSString *)fileName 
      inLine:(int)lineNr
{
	[self log:msg withLevel:SLL_INFO inFile:fileName inLine:lineNr];
}

- (void)debug:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNr
{
	[self log:msg withLevel:SLL_DEBUG inFile:fileName inLine:lineNr];
}

- (void)warn:(NSString *)msg 
      inFile:(NSString *)fileName 
      inLine:(int)lineNr
{
	[self log:msg withLevel:SLL_WARNING inFile:fileName inLine:lineNr];
}

- (void)error:(NSString *)msg 
       inFile:(NSString *)fileName 
       inLine:(int)lineNr
{
	[self log:msg withLevel:SLL_ERROR inFile:fileName inLine:lineNr];
}

@end
