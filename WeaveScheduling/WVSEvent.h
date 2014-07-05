//
//  WVSEvent.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface WVSEvent : NSObject

@property (atomic, retain, readonly) NSString* title;
@property (atomic, retain, readonly) NSString* location;
@property (atomic, retain, readonly) NSDate* startDate;
@property (atomic, retain, readonly) NSDate* endDate;

+ (instancetype) eventWithLocalEvent:(EKEvent*)event;
+ (instancetype) eventWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
