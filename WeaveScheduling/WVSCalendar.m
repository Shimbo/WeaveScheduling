//
//  WVSCalendar.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSCalendar.h"

@implementation WVSCalendar

#pragma mark - Initializers

- (instancetype) initWithLocalEvents
{
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    // Load events
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    NSDate* startDate = [NSDate date];
    _endDate = [NSDate dateWithTimeIntervalSinceNow:86400*WVSCalendarDaysToLoad];
    NSPredicate *predicateForEvents = [eventStore predicateForEventsWithStartDate:startDate endDate:_endDate calendars:nil];
    
    // Initialize our custom events with this data
    _events = [NSMutableArray array];
    NSArray *eventsFound = [eventStore eventsMatchingPredicate:predicateForEvents];
    NSArray *sortedEvents = [eventsFound sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(EKEvent* obj1, EKEvent* obj2) {
        return [obj1.startDate compare:obj2.startDate];
    }];
    for (EKEvent *event in sortedEvents)
    {
        WVSEvent* customEvent = [WVSEvent eventWithLocalEvent:event];
        [_events addObject:customEvent];
    }
    
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary*)calendarData
{
    if ( ! calendarData )
        return nil;
    
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    // Save end date as the max range for the calendar
    _endDate = [calendarData objectForKey:@"endDate"];
    
    // Create events from segments
    NSArray* segments = [calendarData objectForKey:@"segments"];
    _events = [NSMutableArray array];
    for ( NSDictionary* segment in segments )
    {
        NSDate* startDate = [segment objectForKey:@"startDate"];
        NSDate* endDate = [segment objectForKey:@"endDate"];
        WVSEvent* event = [WVSEvent eventWithStartDate:startDate endDate:endDate];
        if ( event )
            [_events addObject:event];
    }
    
    return self;
}

+ (instancetype) calendarWithLocalEvents
{
    WVSCalendar* calendar = [[WVSCalendar alloc] initWithLocalEvents];
    return calendar;
}

+ (instancetype) calendarWithDictionary:(NSDictionary*)calendarData
{
    WVSCalendar* calendar = [[WVSCalendar alloc] initWithDictionary:calendarData];
    return calendar;
}

#pragma mark - Synchronization

- (NSDictionary*) toDictionary
{
    // End date, so we won't try to match after it
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:_endDate forKey:@"endDate"];
    
    // Merging segments of time, at that point events are sorted by start date
    NSMutableArray* segments = [NSMutableArray array];
    NSDate* lastSegmentStartDate = nil;
    NSDate* lastSegmentEndDate = nil;
    NSMutableDictionary* lastSegment = nil;
    for ( NSInteger n = 0; n < _events.count; n++ )
    {
        WVSEvent* event = _events[n];
        
        // Merging segments if the end date for the previous segment is less than meeting duration
        // away from the next segment's start date (i.e. user can't have meeting in between)
        if (lastSegment && [lastSegmentEndDate compare:[event.startDate dateByAddingTimeInterval:-WVSMinimalMeetingDuration]] == NSOrderedDescending)
        {
            lastSegmentEndDate = event.endDate;
            [lastSegment setObject:lastSegmentEndDate forKey:@"endDate"];
        }
        else
        {
            // Otherwise create new segment
            lastSegmentStartDate = [event.startDate copy];
            lastSegmentEndDate = [event.endDate copy];
            lastSegment = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           lastSegmentStartDate, @"startDate",
                           lastSegmentEndDate, @"endDate", nil];
            [segments addObject:lastSegment];
        }
    }
    
    [dictionary setObject:segments forKey:@"segments"];
    return dictionary;
}

@end
