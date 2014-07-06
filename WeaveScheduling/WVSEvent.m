//
//  WVSEvent.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSEvent.h"

@implementation WVSEvent

#pragma mark - Initializers

- (instancetype) initWithLocalEvent:(EKEvent*)event
{
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    _location = event.location;
    _title = event.title;
    _startDate = event.startDate;
    _endDate = event.endDate;
    
    return self;
}

- (instancetype) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    if ( ! startDate || ! endDate )
        return nil;
    
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    _startDate = startDate;
    _endDate = endDate;
    
    return self;
}

- (instancetype) initWithNewEvent:(NSDate*)startDate withTitle:(NSString*)title andLocation:(NSString*)location
{
    if ( ! startDate )
        return nil;
    
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    _startDate = startDate;
    _endDate = [startDate dateByAddingTimeInterval:WVSDefaultMeetingDuration];
    _location = location;
    _title = title;
    
    return self;

}

+ (instancetype) eventWithLocalEvent:(EKEvent*)event
{
    WVSEvent* thisEvent = [[WVSEvent alloc] initWithLocalEvent:event];
    return thisEvent;
}

+ (instancetype) eventWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    WVSEvent* event = [[WVSEvent alloc] initWithStartDate:startDate endDate:endDate];
    return event;
}

+ (instancetype) eventWithNewEvent:(NSDate*)startDate withTitle:(NSString*)title andLocation:(NSString*)location
{
    WVSEvent* event = [[WVSEvent alloc] initWithNewEvent:startDate withTitle:title andLocation:location];
    return event;
}

@end
