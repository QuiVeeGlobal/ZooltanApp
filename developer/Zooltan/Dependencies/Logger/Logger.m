//
//  Logger.m
//  Logger
//
//  Created by Eugene Vegner on 29.05.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#import "Logger.h"

@interface Logger ()
{
    /// <summary>Name of the log file.</summary>
    NSString *_logFileName;
    
    /// <summary>Path of the log file.</summary>
    NSString *_logFilePath;
    
    /// <summary>Flag: append to existing file (if any).</summary>
    BOOL _bAppend;
    
    /// <summary>The log file.</summary>
    //SITStreamWriter *_logFile;
    
    /// <summary>Levels to be logged.</summary>
    NSInteger _levelMask;
    
    /// <summary>The logger's state.</summary>
    LoggerState _state;
    
    /// <summary>Number of debug messages that have been logged.</summary>
    NSInteger _debugMsgs;
    
    /// <summary>Number of informational messages that have been logged.</summary>
    NSInteger _infoMsgs;
    
    /// <summary>Number of success messages that have been logged.</summary>
    NSInteger _successMsgs;
    
    /// <summary>Number of warning messages that have been logged.</summary>
    NSInteger _warningMsgs;
    
    /// <summary>Number of error messages that have been logged.</summary>
    NSInteger _errorMsgs;
    
    /// <summary>Number of fatal messages that have been logged.</summary>
    NSInteger _fatalMsgs;
    
    /// <summary>Number of methods that have been logged.</summary>
    NSInteger _methods;
}

@end


@implementation Logger

#pragma mark - Initialization

+ (Logger *)instance
{
    static dispatch_once_t once;
    static Logger *instance = nil;
    dispatch_once(&once, ^{
        instance = [[Logger alloc] init];
        [instance initialize];
    });
    return instance;
}

- (void)initializeWithFileName:(NSString *)fileName
                       useFile:(BOOL)useFile
                     levelMask:(NSInteger)levelMask
{
    _logFileName = fileName;
    _bAppend = useFile;
    _levelMask = levelMask;
}

- (void)initialize
{
    //Default values
    _logging = NO;
    _state = LoggerStateStopped;
    //_logFile = nil;
    
    _logFileName = [NSString stringWithFormat:@"%@_log_%@",
                    @"AppName",
                    @"00-00-00"];
    
    _bAppend = false;
    //_levelMask = (NSInteger) (LoggerLevelWarning | LoggerLevelError | LoggerLevelFatal);
    _levelMask = (NSInteger)(LoggerLevelAll);
    
    _debugMsgs      = 0;
    _infoMsgs       = 0;
    _successMsgs    = 0;
    _warningMsgs    = 0;
    _errorMsgs      = 0;
    _fatalMsgs      = 0;
    _methods        = 0;
}

#pragma mark - Logging

- (void)setLogging:(BOOL)logging
{
    _logging = logging;
}

#pragma mark - File Path

- (NSString *)documentDirectory {return nil;}


#pragma mark - Setters/Getters

- (void)setLevelMask:(NSInteger)levelMask
{
    _levelMask = levelMask;
}

- (NSInteger)levels
{
    return _levelMask;
}

- (LoggerState)state
{
    return _state;
}

#pragma mark - Write Log

- (BOOL)writeLogMessage:(NSString *)message withLevel:(LoggerLevel)level
{
    if (_state == LoggerStateStopped) {
        return false;
    }
    
    if (_levelMask > LoggerLevelAll || _levelMask < 1) {
        return false;
    }
    
    // Ignore paused
    if (_state == LoggerStatePaused) {
        return true;
    }
    
    //Ignore message logging is paused or it doesn't pass the filter
    if (((_levelMask & level) != level) && (_levelMask != LoggerLevelAll))  {
        return true;
    }
    
    NSString *style = [self levelsToString: level];
    
    NSMutableString *logString = [NSMutableString new];
    [logString appendFormat:@"%@ : %@", [style substringToIndex:1], message];
    
    
    
    
//    [logString appendFormat:@"<div class=%@>%@ %@ : %@</div>",
//     style,
//     [self currentDateString],
//     [style substringToIndex:1],
//     message];

    // Print log
    [self log: logString];
    return true;
}

- (void)log:(NSString*)msg
{
#ifdef DEBUG
    NSLog(@"%@",msg);
#endif
}

#pragma mark - Operations

- (BOOL)start
{
    // Fail if logging has already been started
    if (_state != LoggerStateStopped)
        return false;
    
    // Fail if the log file isn't specified
    if (!_logFileName)
        return false;
    
    // Delete log file if it exists
    //    if (!_bAppend) {
    //        try {
    //            File.Delete (_logFilename);
    //        }
    //        catch (Exception) {
    //            return false;
    //        }
    //    }
    
    //Header log string
    NSMutableString *logString = [NSMutableString stringWithFormat:@"Log Created: %@",[NSDate date]];
    //[logString appendString:@"<head><title>Log Created : "];
    //[logString appendString:@"</title>\r\n<META http-equiv=Content-Type content=\"text/html; charset=windows-1251\">\r\n"];
    //[logString appendString:@"<link href=\"style.css\" type=\"text/css\" rel=\"stylesheet\">\r\n"];
    //[logString appendString:@"</head><pre>"];
    //[logString appendString:@"</head>"];
    
    // Print log
    [self log: logString];
    
    if (_bAppend) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self filePath]]) {
            @try {
                NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath: [self filePath]];
                [fileHandler seekToEndOfFile];
                [fileHandler writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
                [fileHandler closeFile];
            }
            @catch (NSException *exception) {
                return false;
            }
            @finally {}
            
        } else {
            @try {
                NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath: [self filePath]];
                [fileHandler seekToEndOfFile];
                [fileHandler writeData:[logString dataUsingEncoding:NSUTF8StringEncoding]];
                [fileHandler closeFile];
            }
            @catch (NSException *exception) {
                return false;
            }
            @finally {}
        }
    }
    //
    //
    //    @try {
    //        NSString *text = [NSString new];
    //
    //        _logFilePath = [self.documentDirectory stringByAppendingPathComponent: _logFileName];
    //        [text writeToFile:_logFilePath
    //               atomically:YES
    //                 encoding:NSUnicodeStringEncoding
    //                    error:nil];
    //    }
    //    @catch (NSException *exception) {
    //        return false;
    //    }
    _state = LoggerStateRunning;
    return true;
}

- (BOOL)pause
{
    // Fail if logging hasn't been started
    if (_state != LoggerStateRunning)
        return false;
    
    // Pause the logger
    _state = LoggerStatePaused;
    return true;
}

- (BOOL)resume
{
    // Fail if logging hasn't been paused
    if (_state != LoggerStatePaused)
        return false;
    
    // Resume logging
    _state = LoggerStateRunning;
    return true;
}

- (BOOL)stop
{
    // Fail if logging hasn't been started
    if (_state != LoggerStateRunning)
        return false;
    
    // Stop logging
    //    try {
    //        _logFile.Close();
    //        _logFile = null;
    //    }
    //    catch (Exception) {
    //        return false;
    //    }
    _state = LoggerStateStopped;
    return true;
}

- (BOOL)debug:(NSString *)msg
{
    _debugMsgs++;
    return [self writeLogMessage:msg withLevel: LoggerLevelDebug];
}

- (BOOL)info:(NSString *)msg
{
    _infoMsgs++;
    return [self writeLogMessage:msg withLevel: LoggerLevelInfo];
}

- (BOOL)success:(NSString *)msg
{
    _successMsgs++;
    return [self writeLogMessage:msg withLevel: LoggerLevelSuccess];
}

- (BOOL)warning:(NSString *)msg
{
    _warningMsgs++;
    return [self writeLogMessage:msg withLevel: LoggerLevelWarning];
}

- (BOOL)error:(NSString *)msg
{
    _errorMsgs++;
    return [self writeLogMessage:msg withLevel: LoggerLevelError];
}

- (BOOL)fatal:(NSString *)msg
{
    _fatalMsgs++;
    return [self writeLogMessage:msg withLevel: LoggerLevelFatal];
}

- (BOOL)method:(NSString *)msg
{
    _methods++;
    return [self writeLogMessage:msg withLevel: LoggerLevelMethod];
}

- (NSInteger)messagesCountForLevelMask:(NSInteger)levelMask
{
    NSInteger uMessages = 0;
    if ((levelMask & ((NSInteger) LoggerLevelDebug)) != 0)
        uMessages += _debugMsgs;
    if ((levelMask & ((NSInteger) LoggerLevelInfo)) != 0)
        uMessages += _infoMsgs;
    if ((levelMask & ((NSInteger) LoggerLevelSuccess)) != 0)
        uMessages += _successMsgs;
    if ((levelMask & ((NSInteger) LoggerLevelWarning)) != 0)
        uMessages += _warningMsgs;
    if ((levelMask & ((NSInteger) LoggerLevelError)) != 0)
        uMessages += _errorMsgs;
    if ((levelMask & ((NSInteger) LoggerLevelFatal)) != 0)
        uMessages += _fatalMsgs;
    if ((levelMask & ((NSInteger) LoggerLevelMethod)) != 0)
        uMessages += _methods;
    return uMessages;
}


#pragma mark - Helpers

- (NSString *)currentDateString
{
    return [NSString stringWithFormat:@"%@",[NSDate date]];
}

- (NSString *)levelsToString:(LoggerLevel)level
{
    NSString *style = @"Info";
    switch (level) {
        case LoggerLevelDebug:      style = @"Debug";	break;
        case LoggerLevelInfo:       style = @"Info";    break;
        case LoggerLevelSuccess:    style = @"Success";	break;
        case LoggerLevelWarning:    style = @"Warning";	break;
        case LoggerLevelError:      style = @"Error";	break;
        case LoggerLevelFatal:      style = @"Fatal";	break;
        case LoggerLevelMethod:     style = @"Method";	break;
        case LoggerLevelAll:        style = @"All";     break;
        default: break;
    }
    return style;
}

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent: _logFileName];
}

@end
