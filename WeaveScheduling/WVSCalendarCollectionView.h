//
//  LFCCalendarCollectionView.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 12/24/13.
//

#import <UIKit/UIKit.h>
#import "WVSCalendarDailyView.h"

// Custom cell
@interface WVSCalendarCollectionCell : UICollectionViewCell
@property (strong, nonatomic) WVSCalendarDailyView *view;
@end

// Custom layout
@interface WVSCalendarCollectionLayout : UICollectionViewFlowLayout
@end

// Custom collection view
@interface WVSCalendarCollectionView : UICollectionView
@end