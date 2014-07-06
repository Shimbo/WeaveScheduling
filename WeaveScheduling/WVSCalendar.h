//
//  WVSCalendar.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <Foundation/Foundation.h>
#import "WVSEvent.h"

@interface WVSCalendar : NSObject

@property (atomic, retain, readonly) NSDate*          endDate;
@property (atomic, retain, readonly) NSMutableArray*  events;

+ (instancetype) calendarWithLocalEvents;
+ (instancetype) calendarWithDictionary:(NSDictionary*)calendarData;

- (NSDictionary*) toDictionary;

- (NSArray*) mergedSegments;
- (NSArray*) mutuallyUnavailableSegments:(WVSCalendar*)otherCalendar;

- (BOOL) checkTimeAvailability:(NSDate*)date;

@end
