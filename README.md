GRLogger
========

I started my iOS dev (it calls iPhone dev then) from May, 2009.  I composed a logger utility for debugging
and tracing.  I used them within 2 iOS apps and it give me a lot of help.  Today I want to open source it
to public.  

License: MIT

Install:
  (1) Add GRLogger.h, GRLogger.m and License into your project
  (2) Sample -- Please refer to main.m  
    #import "GRLogger.h"
      
    int foo()
    {
      ENTER(@"foo");
      RETURN(10, @"foo");
    }

    int main(int argc, char *argv[])
    {
      @autoreleasepool {
        SETLOGLEVEL(SLLS_ALL);
        INFO(@"info");
        DBG(@"debug value is %d", 3);
        WARN(@"warning");
        ERROR(@"error");
        FATAL(@"fatal");
        LOG(SLL_TINY, @"tiny");
        foo();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
       }
    }
    
    The output is as below:
    2012-05-29 01:10:42.859 GRLogger[42610:f803] FILE:main.m LINE:25 [INFO] info
    2012-05-29 01:10:42.867 GRLogger[42610:f803] FILE:main.m LINE:26 [DEBUG] debug value is 3
    2012-05-29 01:10:42.868 GRLogger[42610:f803] FILE:main.m LINE:27 [WARN] warning
    2012-05-29 01:10:42.869 GRLogger[42610:f803] FILE:main.m LINE:28 [ERROR] error
    2012-05-29 01:10:42.870 GRLogger[42610:f803] FILE:main.m LINE:29 [FATAL] fatal
    2012-05-29 01:10:42.872 GRLogger[42610:f803] FILE:main.m LINE:30 [TINY] tiny
    2012-05-29 01:10:42.873 GRLogger[42610:f803] FILE:main.m LINE:17 [ENTER] foo
    2012-05-29 01:10:42.874 GRLogger[42610:f803] FILE:main.m LINE:18 [RETURN] foo
    
Documentation:
  (1) SETLOGLEVEL(SLLS_ALL); 
  
  typedef enum {
    SLLS_ALL = 0, 
    SLLS_MINOR = 21, 
    SLLS_MEDIUM = 35,
    SLLS_MAJOR = 45,
    SLLS_NONE = 1000,
    SLLS_DEFAULT = SLLS_MAJOR // SLLS_DEFAULT = SLLS_MAJOR
  } GRLoggerLevelSetting;
  If you set values other than GRLoggerLevelSetting, it uses SLLS_DEFAULT
  Usually we use SLLS_ALL, SLLS_MAJOR (just INFO, WARN, ERROR, FATAL) and SLLS_NONE.

  (2) If you want to close GRLogger, you have 2 approaches:
    (a) SETLOGLEVEL(SLLS_NONE);
    (b) defined __SELF_DEFING_CLOSEGRLOGGER__ (better than (a))

      