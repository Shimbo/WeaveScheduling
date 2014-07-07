//
//  WVSCalendarDailyView.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSCalendarDailyView.h"

@implementation WVSCalendarDailyView

- (void) setupDay:(NSDate*)day fromEvents:(NSArray*)events andSegments:(NSArray*)segments
{
    // Top label
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDoesRelativeDateFormatting:YES];
    _dayLabel.text = [formatter stringFromDate:day];
    
    // Past time block for today
    if ( daysBetweenDates( day, [NSDate date]) == 0 )
    {
        WVSCalendarEventView* eventView = [[WVSCalendarEventView alloc] initForTheDay:day withSegment:[WVSSegment segmentWithStartDate:day endDate:[NSDate date]] andType:WVSEventTypePast];
        if ( eventView )
            [self addSubview:eventView];
    }
    
    // Opponent's calendar first, mark with gray
    for ( WVSSegment* segment in segments )
    {
        // Get segment view
        WVSCalendarEventView* eventView = [[WVSCalendarEventView alloc] initForTheDay:day withSegment:segment andType:WVSEventTypeAnother];
        if ( eventView )
            [self addSubview:eventView];
    }
    
    // User's calendar, mark with blue
    for ( WVSEvent* event in events )
    {
        // Get segment view
        WVSCalendarEventView* eventView = [[WVSCalendarEventView alloc] initForTheDay:day withSegment:event andType:WVSEventTypeOwn];
        if ( eventView )
            [self addSubview:eventView];
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
