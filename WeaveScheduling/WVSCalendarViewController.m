//
//  WVSCalendarViewController.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSCalendarViewController.h"
#import "WVSCalendarCollectionView.h"

@implementation WVSCalendarViewController

- (id) initWithCalendarThis:(WVSCalendar*)thisCalendar andCalendarThat:(WVSCalendar*)thatCalendar
{
    self = [super init];
    if ( ! self )
        return nil;
    
    _thisCalendar = thisCalendar;
    _thatCalendar = thatCalendar;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Schedule"];
    
    [_scrollView setContentSize:CGSizeMake(self.view.width, WVSCustomCellSize.height)];
    
    [_collectionView registerClass:[WVSCalendarCollectionCell class] forCellWithReuseIdentifier:@"dayCell"];
    _collectionView.collectionViewLayout = [[WVSCalendarCollectionLayout alloc] init];
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    _collectionView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    _collectionView.height = WVSCustomCellSize.height;
    
    for ( NSInteger n = 0; n < WVSHoursToShowInCalendar+1; n++ )
    {
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -2+50*n, 36, 22)];
        timeLabel.text = [NSString stringWithFormat:@"%d", n+WVSFirstHourInCalendar];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:14];
        [_timeView addSubview:timeLabel];
    }
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return WVSCalendarDaysToLoad;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WVSCalendarDailyView* dailyView = [[[NSBundle mainBundle] loadNibNamed:@"WVSCalendarDailyView" owner:self options:nil] objectAtIndex:0];
    
    // Remove hours/stuff from days
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:86400*indexPath.row];
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    // Setup day view
    [dailyView setupDay:date fromEvents:_thisCalendar.events andSegments:_thatCalendar.events];
    
    // Setup cell
    WVSCalendarCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
    [cell.view removeFromSuperview];
    [cell addSubview:dailyView];
    cell.view = dailyView;
    cell.view.dayLabel.originY = _scrollView.contentInset.top + _scrollView.contentOffset.y;
    if ( cell.view.dayLabel.originY < 0 )
        cell.view.dayLabel.originY = 0;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, WVSCustomCellSpacing*UNI_COEF, 0, WVSCustomCellSpacing*UNI_COEF);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return WVSCustomCellSpacing*UNI_COEF;
}

#pragma mark - ScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ( scrollView != _scrollView )
        return;
    
    CGFloat pageWidth = WVSCustomCellSize.width;
    NSInteger currentPage = _collectionView.contentOffset.x / pageWidth;
    NSInteger visiblePages = _collectionView.width / pageWidth + 1;
    
    for ( NSInteger n = 0; n < visiblePages; n++ )
    {
        WVSCalendarCollectionCell* cell = (WVSCalendarCollectionCell*) [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage+n inSection:0]];
        cell.view.dayLabel.originY = _scrollView.contentInset.top + _scrollView.contentOffset.y;
        //if ( cell.view.dayLabel.originY < 0 )
        //    cell.view.dayLabel.originY = 0;
    }
}

@end
