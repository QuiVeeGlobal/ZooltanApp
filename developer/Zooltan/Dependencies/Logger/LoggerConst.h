//
//  Constants.h
//  Logger
//
//  Created by Eugene Vegner on 29.05.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#ifndef Logger_Constants_h
#define Logger_Constants_h


/** Log levels.*/
typedef enum : NSUInteger {
    LoggerLevelDebug    = 1,        //Log debug messages
    LoggerLevelInfo     = 2,        //Log informational messages
    LoggerLevelSuccess  = 4,        //Log success messages
    LoggerLevelWarning  = 8,        //Log warning messages
    LoggerLevelError    = 16,       //Log error messages
    LoggerLevelFatal    = 32,       //Log fatal errors
    LoggerLevelMethod   = 64,       //Log fatal errors
    LoggerLevelAll      = 128,      //Log all messages
} LoggerLevel;

/** The logger's state. */
typedef enum : NSUInteger {
    LoggerStateStopped  = 0,//The logger is stopped
    LoggerStateRunning,     //The logger has been started
    LoggerStatePaused,      //The logger is paused
} LoggerState;


#endif
