GRLogger
========

I started my iOS dev (it calls iPhone dev then) from May, 2009.  I composed a logger utility for debugging
and tracing.  I used them within 2 iOS apps and it gives me a lot of help.  Today I want to open source it
to public.  

License: MIT

Install:<br>
  (1) Add GRLogger.h, GRLogger.m and License into your project or <br>
      pod 'GRLogger',       '~> 1.0.5' <br>
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
    
Documentation:<br>
  (1) SETLOGLEVEL(SLLS_ALL); 
  
  typedef enum {  <br>
    SLLS_ALL = 0, <br>
    SLLS_MAJOR = 45, <br>
    SLLS_MINOR = 65, <br>
    SLLS_NONE = 1000, <br>
    SLLS_DEFAULT = SLLS_MAJOR // SLLS_DEFAULT = SLLS_MAJOR<br>
  } GRLoggerLevelSetting; <br>
  If you set values other than GRLoggerLevelSetting, it uses SLLS_DEFAULT
  Usually we use SLLS_ALL, SLLS_MAJOR (just INFO, WARN, ERROR, FATAL) and SLLS_NONE.

  (2) If you want to close GRLogger, you have 2 approaches:
    <ul>
     <li>SETLOGLEVEL(SLLS_NONE);</li><li>defined __SELF_DEFING_CLOSEGRLOGGER__ (better) </li>
    </ul>

TODO:
  (1) Support log into files
