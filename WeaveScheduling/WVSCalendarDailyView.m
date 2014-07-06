//
//  WVSCalendarDailyView.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSCalendarDailyView.h"
#import "WVSEvent.h"

@implementation WVSCalendarDailyView

- (UIView*) createViewForDay:(NSDate*)day withStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate strict:(BOOL)strict
{
    NSDate* dayEnds = [day dateByAddingTimeInterval:86400];
    
    // Check if segment doesn't intersect with this day
    NSComparisonResult startResult = [startDate compare:day];
    NSComparisonResult endResult = [endDate compare:dayEnds];
    if ( startResult == endResult )
        return nil;
    
    // Extract hours
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:startDate];
    float startHours = (float)[components hour] + ((float)[components minute])/60.0;
    components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:endDate];
    float endHours = (float)[components hour] + ((float)[components minute])/60.0;
    
    // Hide events that are out of the main range. Used for other's calendar events
    if ( strict )
    {
        if ( startHours >= WVSFirstHourInCalendar + WVSHoursToShowInCalendar )
            return nil;
        if ( endHours <= WVSFirstHourInCalendar )
            return nil;
    }
    
    UIView* segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
    if ( [startDate compare:day] == NSOrderedAscending )
        segmentView.originY = 0;
    else
        segmentView.originY = (startHours - (float)WVSFirstHourInCalendar)*(float)WVSDayViewRowHeight + WVSDayViewHeaderHeight + WVSDayViewTopOffset;
    
    segmentView.height = (float)WVSDayViewRowHeight*([endDate timeIntervalSince1970] - [startDate timeIntervalSince1970])/WVSDayViewRowInSeconds;
    
    return segmentView;
}

- (void) setupDay:(NSDate*)day fromEvents:(NSArray*)events andSegments:(NSArray*)segments
{
    // Top label
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    _dayLabel.text = [formatter stringFromDate:day];
    
    // Opponent's calendar first, mark with gray
    for ( WVSSegment* segment in segments )
    {
        // Get segment view
        UIView* segmentView = [self createViewForDay:day withStartDate:segment.startDate andEndDate:segment.endDate strict:YES];
        if ( ! segmentView )
            continue;
        
        // Init it with other user's segment
        segmentView.backgroundColor = [UIColor colorWithHexString:@"bebebe"];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width, 20)];
        label.text = @"Nina not available";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        [segmentView addSubview:label];
        
        [self addSubview:segmentView];
    }
    
    // User's calendar, mark with blue
    for ( WVSEvent* event in events )
    {
        // Get segment view
        UIView* segmentView = [self createViewForDay:day withStartDate:event.startDate andEndDate:event.endDate strict:NO];
        if ( ! segmentView )
            continue;
        
        // Init it with user's event (TODO: refactor it to a separate class with two initializers)
        segmentView.backgroundColor = [UIColor colorWithHexString:@"7794cb"];
        
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
        [segmentView addSubview:label];
        
        [self addSubview:segmentView];
    }
    
    [self bringSubviewToFront:_dayLabel];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // Initializing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.25f);
    
    // Filling everything as available
    /*CGRect frame = CGRectMake(0, WVSDayViewHeaderHeight + WVSDayViewTopOffset, self.width, WVSDayViewRowHeight * WVSHoursToShowInCalendar);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"FFFFFF"].CGColor);
    CGContextFillRect(context, frame);*/
    
    // Drawing lines in between
    for ( NSInteger n = 0; n < 24; n ++ )
    {
        CGContextMoveToPoint(context, 0.0f, n*WVSDayViewRowHeight + WVSDayViewHeaderHeight + WVSDayViewTopOffset);
        CGContextAddLineToPoint(context, self.width, n*WVSDayViewRowHeight + WVSDayViewHeaderHeight + WVSDayViewTopOffset);
    }
    
    // Side lines
    CGContextMoveToPoint(context, self.width, 0.0f);
    CGContextAddLineToPoint(context, self.width, self.height);
    
    // Finalize lines drawing
    CGContextStrokePath(context);
}

@end
