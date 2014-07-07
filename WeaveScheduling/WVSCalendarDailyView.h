//
//  WVSCalendarDailyView.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import "WVSEvent.h"
#import "WVSCalendarEventView.h"

@interface WVSCalendarDailyView : UIView

@property (strong, nonatomic) IBOutlet UILabel *dayLabel;

- (void) setupDay:(NSDate*)day fromEvents:(NSArray*)events andSegments:(NSArray*)segments;

@end
