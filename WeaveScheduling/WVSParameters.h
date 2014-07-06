//
//  WVSParameters.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

// Logic
static const NSInteger WVSCalendarDaysToLoad = 30;
static const NSTimeInterval WVSMinimalMeetingDuration = 3600.0;
static const NSTimeInterval WVSDefaultMeetingDuration = 3600.0;

// Custom calendar view
static const NSInteger WVSFirstHourInCalendar   = 9;
static const NSInteger WVSHoursToShowInCalendar = 12;

// Caledar day view
static const NSInteger WVSDayViewHeaderHeight = 50;
static const NSInteger WVSDayViewRowHeight = 50;
static const NSTimeInterval WVSDayViewRowInSeconds = 3600.0;
static const NSInteger WVSDayViewTopOffset = 10;
static const CGSize WVSDayViewSize = (CGSize){240, WVSDayViewHeaderHeight + WVSDayViewRowHeight*WVSHoursToShowInCalendar + WVSDayViewTopOffset*2};
static const CGFloat WVSDayViewSpacing = 0.0f;

// New meeting view
static const NSTimeInterval WVSNewMeetingThreshold = 1800.0; // in seconds, i.e. 9:00, 9:30, etc