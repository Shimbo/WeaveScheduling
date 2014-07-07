//
//  WVSCalendarEventView.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/6/14.
//
//

#import "WVSCalendarEventView.h"

@implementation WVSCalendarEventView

- (void) setupControlsForPast
{
    self.backgroundColor = [UIColor colorWithHexString:@"bebebe"];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width, 20)];
    label.text = @"Past time";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    [self addSubview:label];
}

- (void) setupControlsForAnother
{
    self.backgroundColor = [UIColor colorWithHexString:@"bebebe"];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width, 20)];
    label.text = @"Nina not available"; // Note for future use: replace with another user's name
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    [self addSubview:label];
}

- (void) setupControlsForOwn
{
    if ( ! [_segment isKindOfClass:[WVSEvent class]] )
    {
        NSLog(@"Casting error, segment was passed instead of event");
        return;
    }
    
    WVSEvent* event = (WVSEvent*)_segment;
    
    self.backgroundColor = [UIColor colorWithHexString:@"7794cb"];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width, 40)];
    NSString* titleString = event.title;
    if ( ! titleString )
        titleString = @"";
    NSString* locationString = event.location;
    if ( ! locationString )
        locationString = @"";
    label.text = [NSString stringWithFormat:@"%@\n%@", titleString, locationString];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
}

- (id) initForTheDay:(NSDate*)day withSegment:(WVSSegment*)segment andType:(WVSEventType)type
{
    _segment = segment;
    
    self = [super initWithFrame:CGRectMake(0, 0, WVSDayViewSize.width, 1)];
    if (! self)
        return nil;
    
    NSDate* dayEnds = [day dateByAddingTimeInterval:86400];
    
    // Check if segment doesn't intersect with this day
    NSComparisonResult startResult = [segment.startDate compare:day];
    NSComparisonResult endResult = [segment.endDate compare:dayEnds];
    if ( startResult == endResult )
        return nil;
    
    // Extract hours
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:segment.startDate];
    float startHours = (float)[components hour] + ((float)[components minute])/60.0;
    components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:segment.endDate];
    float endHours = (float)[components hour] + ((float)[components minute])/60.0;
    
    // Hide events that are out of the main range. Used for other's calendar events
    if ( type != WVSEventTypeOwn )
    {
        if ( startHours >= WVSFirstHourInCalendar + WVSHoursToShowInCalendar )
            return nil;
        if ( endHours <= WVSFirstHourInCalendar )
            return nil;
    }
    
    // Adjusting the view for an all day event to a reasonable visible range
    NSInteger offset = (type == WVSEventTypeOwn ? 1 : 0);
    if ( startHours < WVSFirstHourInCalendar - offset )
    {
        startHours = WVSFirstHourInCalendar - offset ;
        if ( startHours >= endHours )
            return nil;
    }
    if ( endHours > WVSFirstHourInCalendar + WVSHoursToShowInCalendar + offset )
    {
        endHours = WVSFirstHourInCalendar + WVSHoursToShowInCalendar + offset;
        if ( endHours <= startHours )
            return nil;
    }
    
    // Updating vertical position and height
    self.originY = (startHours - (float)WVSFirstHourInCalendar)*(float)WVSDayViewRowHeight + WVSDayViewHeaderHeight + WVSDayViewTopOffset;
    self.height = (float)WVSDayViewRowHeight*(endHours - startHours);
    
    // Setting up labels and other content
    switch (type)
    {
        case WVSEventTypeAnother: [self setupControlsForAnother]; break;
        case WVSEventTypeOwn: [self setupControlsForOwn]; break;
        case WVSEventTypePast: [self setupControlsForPast]; break;
        default: break;
    }
    
    return self;
}

- (id) initWithNewMeeting:(WVSEvent*)meeting
{
    self = [super initWithFrame:CGRectMake(0, 0, WVSDayViewSize.width, WVSDayViewRowHeight*WVSDefaultMeetingDuration/WVSDayViewRowInSeconds)];
    if (! self)
        return nil;
    
    _segment = meeting;
    
    self.backgroundColor = [UIColor colorWithHexString:@"5ffdb8"];
    
    // Label
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width, 40)];
    NSString* titleString = meeting.title;
    NSString* locationString = @"Tap \"Done\" to finish";
    label.text = [NSString stringWithFormat:@"%@\n%@", titleString, locationString];
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    
    return self;
}

@end
