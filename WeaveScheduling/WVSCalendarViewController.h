//
//  WVSCalendarViewController.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import "WVSCalendarDailyView.h"
#import "WVSCalendar.h"

@interface WVSCalendarViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UICollectionView *_collectionView;
    IBOutlet UIView *_timeView;
    
    WVSCalendar* _ownCalendar;
    WVSCalendar* _otherCalendar;
}

- (id) initWithOwnCalendar:(WVSCalendar*)ownCalendar andOtherCalendar:(WVSCalendar*)otherCalendar;

@end
