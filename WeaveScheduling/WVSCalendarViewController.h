//
//  WVSCalendarViewController.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import "WVSCalendarDailyView.h"
#import "WVSCalendarEventView.h"
#import "WVSCalendar.h"

@interface WVSCalendarViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UIView *_timeView;
    
    // Calendars passed from outside
    WVSCalendar* _ownCalendar;
    WVSCalendar* _anotherCalendar;
    
    // Views for days
    WVSCalendarDailyView*  _dayViews[WVSCalendarDaysToLoad];
    
    // New meeting data and view
    WVSEvent*               _meeting;
    WVSCalendarEventView*   _meetingView;
    
    // Cached for scrolling
    NSInteger   _dayToAddNewMeeting;
    
    // Temporary flag to restore navigation bar
    BOOL        _calledFromRoot;
}

- (id) initWithOwnCalendar:(WVSCalendar*)ownCalendar anotherCalendar:(WVSCalendar*)anotherCalendar andMeeting:(WVSEvent*)meeting;

@end
