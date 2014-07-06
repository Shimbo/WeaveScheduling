//
//  WVSEvent.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "WVSSegment.h"

@interface WVSEvent : WVSSegment

@property (atomic, retain, readonly) NSString* title;
@property (atomic, retain, readonly) NSString* location;

+ (instancetype) eventWithLocalEvent:(EKEvent*)event;
+ (instancetype) eventWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
+ (instancetype) eventWithNewEvent:(NSDate*)startDate withTitle:(NSString*)title andLocation:(NSString*)location;

@end
