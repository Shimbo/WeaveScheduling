//
//  WVSCalendarViewController.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSCalendarViewController.h"
#import "WVSCalendarCollectionView.h"
#import "WVSNewMeetingViewController.h"

@implementation WVSCalendarViewController

- (id) initWithOwnCalendar:(WVSCalendar*)ownCalendar anotherCalendar:(WVSCalendar*)anotherCalendar andMeeting:(WVSEvent*)meeting
{
    self = [super init];
    if ( ! self )
        return nil;
    
    _ownCalendar = ownCalendar;
    _anotherCalendar = anotherCalendar;
    _calledFromRoot = ! meeting;
    _meeting = meeting;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Schedule"];
    
    _dayToAddNewMeeting = -1;
    
    // Update scrollview size
    [_scrollView setContentSize:CGSizeMake(self.view.width, WVSDayViewSize.height)];
    
    // Prepare collection view
    [_collectionView registerClass:[WVSCalendarCollectionCell class] forCellWithReuseIdentifier:@"dayCell"];
    _collectionView.collectionViewLayout = [[WVSCalendarCollectionLayout alloc] init];
    _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    _collectionView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    _collectionView.height = WVSDayViewSize.height;
    
    // Create time table on the left
    for ( NSInteger n = 0; n < WVSHoursToShowInCalendar+1; n++ )
    {
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -2+50*n, 36, 22)];
        timeLabel.text = [NSString stringWithFormat:@"%d", n+WVSFirstHourInCalendar];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.font = [UIFont systemFontOfSize:14];
        [_timeView addSubview:timeLabel];
    }
    
    // Creating new meeting view if needed
    if ( _meeting )
    {
        [self createNewMeetingView:_meeting.startDate];
        _dayToAddNewMeeting = daysBetweenDates([NSDate date], _meeting.startDate);
        if ( _dayToAddNewMeeting >= WVSCalendarDaysToLoad )
            _dayToAddNewMeeting = -1;
    }
    
    // Create daily views
    for ( NSInteger n = 0; n < WVSCalendarDaysToLoad; n++ )
    {
        WVSCalendarDailyView* dailyView = [[[NSBundle mainBundle] loadNibNamed:@"WVSCalendarDailyView" owner:self options:nil] objectAtIndex:0];
        
        // Create date without hour/minute components
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:86400*n];
        NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        // Setup day view
        [dailyView setupDay:date fromEvents:_ownCalendar.events andSegments:_anotherCalendar.events];
        
        // Adding new meeting view if needed
        if ( _dayToAddNewMeeting == n )
        {
            [dailyView addSubview:_meetingView];
            [dailyView bringSubviewToFront:dailyView.dayLabel]; // TODO (to initializer too)
        }
        
        _dayViews[n] = dailyView;
    }
    
    // Tap recognizer for collection
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionHandleTap:)];
    [_collectionView addGestureRecognizer:tapRecognizer];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Scroll to day needed
    if ( _meeting && _dayToAddNewMeeting >= 0 )
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_dayToAddNewMeeting inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if ( _calledFromRoot )
            self.navigationController.navigationBar.hidden = YES;
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark - CollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return WVSCalendarDaysToLoad;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WVSCalendarDailyView* dailyView = _dayViews[indexPath.row];
    
    // Setup cell
    WVSCalendarCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
    [cell.view removeFromSuperview];
    [cell addSubview:dailyView];
    cell.view = dailyView;
    cell.view.dayLabel.originY = _scrollView.contentInset.top + _scrollView.contentOffset.y;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, WVSDayViewSpacing*UNI_COEF, 0, WVSDayViewSpacing*UNI_COEF);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return WVSDayViewSpacing*UNI_COEF;
}

#pragma mark - CollectionView tap handling

- (NSTimeInterval)timeFromTapPosition:(CGPoint)pointInCell
{
    NSTimeInterval proposedTime = (pointInCell.y - WVSDayViewHeaderHeight - WVSDayViewTopOffset) * WVSDayViewRowInSeconds / WVSDayViewRowHeight;
    NSInteger intervalCount = round(proposedTime / WVSNewMeetingThreshold);
    proposedTime = intervalCount * WVSNewMeetingThreshold + WVSFirstHourInCalendar * 3600.0;
    return proposedTime;
}

- (void)createNewMeetingView:(NSDate*)date
{
    // Daytime calculation
    NSDateComponents* components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date];
    NSTimeInterval time = [components hour]*3600 + [components minute]*60 + [components second];
    
    // Calculate view position
    NSInteger verticalPosition = (time / WVSDayViewRowInSeconds - WVSFirstHourInCalendar) * WVSDayViewRowHeight + WVSDayViewHeaderHeight + WVSDayViewTopOffset;
    
    // Create meeting view if needed
    if ( ! _meetingView )
    {
        // TODO: here's the third initializer for meeting view separate class
        _meetingView = [[UIView alloc] initWithFrame:CGRectMake(0, verticalPosition, WVSDayViewSize.width, WVSDayViewRowHeight*WVSDefaultMeetingDuration/WVSDayViewRowInSeconds)];
        _meetingView.backgroundColor = [UIColor colorWithHexString:@"5ffdb8"];
        
        // Label
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _meetingView.width, 40)];
        NSString* titleString = @"Nina and Username";
        NSString* locationString = @"Tap \"Done\" to finish";
        label.text = [NSString stringWithFormat:@"%@\n%@", titleString, locationString];
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:14];
        [_meetingView addSubview:label];
    }
    else // otherwise remove it from previous cell before adding again
    {
        _meetingView.originY = verticalPosition;
        [_meetingView removeFromSuperview];
    }
}

- (void)collectionHandleTap:(UITapGestureRecognizer*)sender{
    
    // Calculating tap point and tapped cell
    CGPoint tapPoint = [sender locationInView:_collectionView];
    NSInteger cell = tapPoint.x / WVSDayViewSize.width;
    
    // Tapping on a view that wasn't initialized (impossible, but just in case)
    if ( ! _dayViews[cell] )
        return;
    
    // Positioning inside the cell
    CGPoint pointInCell = CGPointMake(((NSInteger)tapPoint.x % (NSInteger)WVSDayViewSize.width), tapPoint.y);
    
    // Return if tapped on the header section
    if ( pointInCell.y < WVSDayViewHeaderHeight )
        return;
    
    // Centering and fixing edge cases
    pointInCell.y -= WVSDayViewRowHeight / 2.0;
    if ( pointInCell.y < WVSDayViewHeaderHeight + WVSDayViewTopOffset )
        pointInCell.y = WVSDayViewHeaderHeight + WVSDayViewTopOffset;
    if ( pointInCell.y > WVSDayViewSize.height - WVSDayViewTopOffset - WVSDayViewRowHeight )
        pointInCell.y = WVSDayViewSize.height - WVSDayViewTopOffset - WVSDayViewRowHeight;
    
    // Calculating rounded time
    NSTimeInterval proposedTime = [self timeFromTapPosition:pointInCell];
    
    // Calculating midnight date and adding proposed time
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:86400*cell];
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    date = [date dateByAddingTimeInterval:proposedTime];
    
    // Check if this time slot is unavailable
    BOOL availableThis = [_ownCalendar checkTimeAvailability:date];
    BOOL availableThat = [_anotherCalendar checkTimeAvailability:date];
    if ( ! availableThis || ! availableThat )
        return;
    
    // Create or update meeting if created
    if ( ! _meeting )
        _meeting = [WVSEvent eventWithNewEvent:date withTitle:@"Nina and Username" andLocation:@"Creamery"];
    else
    {
        _meeting.startDate = date;
        _meeting.endDate = [date dateByAddingTimeInterval:WVSDefaultMeetingDuration];
    }
    
    // Creating meeting view and adding to the day cell
    [self createNewMeetingView:date];
    [_dayViews[cell] addSubview:_meetingView];
    [_dayViews[cell] bringSubviewToFront:_dayViews[cell].dayLabel]; // TODO (to initializer too)
    
    // Enable done button
    if ( ! self.navigationItem.rightBarButtonItem )
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTapped:)];
        self.navigationItem.rightBarButtonItem = doneButton;
    }
}

#pragma mark - ScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // Check that we are scrolling scroll view and not collection view
    if ( scrollView != _scrollView )
        return;
    
    // Calculate visible pages
    CGFloat pageWidth = WVSDayViewSize.width;
    NSInteger currentPage = _collectionView.contentOffset.x / pageWidth;
    NSInteger visiblePages = _collectionView.width / pageWidth + 1;
    
    // Keep day labels for visible pages always on top
    for ( NSInteger n = 0; n < visiblePages; n++ )
    {
        WVSCalendarCollectionCell* cell = (WVSCalendarCollectionCell*) [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage+n inSection:0]];
        cell.view.dayLabel.originY = _scrollView.contentInset.top + _scrollView.contentOffset.y;
    }
}

#pragma mark - Done tapped

-(IBAction)doneTapped:(id)sender
{
    // If we were editing existing meeting, we should just pop back
    if ( ! _calledFromRoot )
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // Otherwise we should replace this view with meeting view
    NSMutableArray* newViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    WVSNewMeetingViewController* meetingView = [[WVSNewMeetingViewController alloc] initWithOwnCalendar:_ownCalendar anotherCalendar:_anotherCalendar andMeeting:_meeting];
    [newViewControllers replaceObjectAtIndex:newViewControllers.count-1 withObject:meetingView];
    [self.navigationController setViewControllers:newViewControllers animated:YES];
}

@end
