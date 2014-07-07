//
//  WVSCalendarEventView.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/6/14.
//
//

#import <UIKit/UIKit.h>
#import "WVSEvent.h"

typedef enum EventType
{
    WVSEventTypeOwn     = 0,
    WVSEventTypeAnother = 1,
    WVSEventTypeNew     = 2,
    WVSEventTypePast    = 3
} WVSEventType;

@interface WVSCalendarEventView : UIView
{
    WVSSegment* _segment;
}

- (id) initForTheDay:(NSDate*)day withSegment:(WVSSegment*)segment andType:(WVSEventType)type;
- (id) initWithNewMeeting:(WVSEvent*)meeting;

@end
