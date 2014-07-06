//
//  WVSParameters.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

static const NSInteger WVSCalendarDaysToLoad = 30;
static const NSTimeInterval WVSMinimalMeetingDuration = 3600.0;

static const NSInteger WVSFirstHourInCalendar   = 9;
static const NSInteger WVSHoursToShowInCalendar = 12;

// UI
static const NSInteger WVSDayViewHeaderHeight = 50;
static const NSInteger WVSDayViewRowHeight = 50;
static const NSInteger WVSDayViewTopOffset = 10;
static const CGSize WVSCustomCellSize = (CGSize){240, WVSDayViewHeaderHeight + WVSDayViewRowHeight*WVSHoursToShowInCalendar + WVSDayViewTopOffset*2};
static const CGFloat WVSCustomCellSpacing = 0.0f;