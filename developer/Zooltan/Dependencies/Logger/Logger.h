//
//  Logger.h
//  Logger
//
//  Created by Eugene Vegner on 29.05.14.
//  Copyright (c) 2014 Eugene Vegner. All rights reserved.
//

#define STLog(format, ...)          [[Logger instance] log: \
[NSString stringWithFormat:format, ##__VA_ARGS__]]

#define STLogInfo(format, ...)      [[Logger instance] info: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
[NSString stringWithFormat:format, ##__VA_ARGS__]]]

#define STLogDebug(format, ...)     [[Logger instance] debug: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
[NSString stringWithFormat:format, ##__VA_ARGS__]]]

#define STLogSuccess(format, ...)   [[Logger instance] success: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
[NSString stringWithFormat:format, ##__VA_ARGS__]]]

#define STLogWarning(format, ...)   [[Logger instance] warning: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
[NSString stringWithFormat:format, ##__VA_ARGS__]]]

#define STLogFatal(format, ...)     [[Logger instance] fatal: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
[NSString stringWithFormat:format, ##__VA_ARGS__]]]

#define STLogMethod \
[[Logger instance] method: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
NSStringFromSelector(_cmd)]]

#define STLogException(__NSException) \
[[Logger instance] fatal: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class),\
__NSException.reason]]

#define STLogError(__NSError) \
[[Logger instance] error: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
__NSError.localizedDescription]]

#define STLogErrorMsg(format, ...)   [[Logger instance] error: \
[NSString stringWithFormat:@"[%@] : %@",NSStringFromClass(self.class), \
[NSString stringWithFormat:format, ##__VA_ARGS__]]]



#import <Foundation/Foundation.h>
#import "LoggerConst.h"

@interface Logger : NSObject
/// <summary>
/// Retrieves the logger's state.
/// </summary>
@property (nonatomic, assign) LoggerState state;

@property (nonatomic, assign) BOOL logging;

/// <summary>
/// Gets and sets the log level.
/// </summary>
@property (nonatomic, assign) NSInteger levelMask;

/// <summary>
/// Logger shared instance.
/// </summary>
+ (Logger *)instance;


/// <summary>
/// Constructs a Logger.
/// </summary>
/// <param name="logFilename">Log file to receive output.</param>
/// <param name="bAppend">Flag: append to existing file (if any).</param>
/// <param name="logLevels">Mask indicating log levels of interest.</param>
- (void)initializeWithFileName:(NSString *)fileName
                       useFile:(BOOL)useFile
                     levelMask:(NSInteger)levelMask;

/// <summary>
/// Starts logging.
/// </summary>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)start;

/// <summary>
/// Temporarily suspends logging.
/// </summary>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)pause;

/// <summary>
/// Resumes logging.
/// </summary>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)resume;

/// <summary>
/// Stops logging.
/// </summary>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)stop;

/// <summary>
/// Logs a debug message.
/// </summary>
/// <param name="msg">The message.</param>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)debug:(NSString*)msg;

/// <summary>
/// Logs an informational message.
/// </summary>
/// <param name="msg">The message.</param>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)info:(NSString*)msg;

/// <summary>
/// Logs a success message.
/// </summary>
/// <param name="msg">The message.</param>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)success:(NSString*)msg;

/// <summary>
/// Logs a warning message.
/// </summary>
/// <param name="msg">The message.</param>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)warning:(NSString*)msg;

/// <summary>
/// Logs an error message.
/// </summary>
/// <param name="msg">The message.</param>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)error:(NSString*)msg;

/// <summary>
/// Logs a fatal error message.
/// </summary>
/// <param name="msg">The message.</param>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)fatal:(NSString*)msg;

/// <summary>
/// Logs a methods message.
/// </summary>
/// <param name="msg">The message.</param>
/// <returns>true if successful, false otherwise.</returns>
- (BOOL)method:(NSString*)msg;

/// <summary>
/// Retrieves the count of messages logged at one or more levels.
/// </summary>
/// <param name="levelMask">Mask indicating levels of interest.</param>
/// <returns></returns>
- (NSInteger)messagesCountForLevelMask:(NSInteger)levelMask;

/** Print log */
- (void)log:(NSString*)msg;

@end
