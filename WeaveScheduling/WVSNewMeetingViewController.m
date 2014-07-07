//
//  WVSNewMeetingViewController.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/6/14.
//
//

#import "WVSNewMeetingViewController.h"
#import "WVSCalendarViewController.h"

@implementation WVSNewMeetingViewController

- (id) initWithOwnCalendar:(WVSCalendar*)ownCalendar anotherCalendar:(WVSCalendar*)anotherCalendar andMeeting:(WVSEvent *)meeting
{
    self = [super init];
    if ( ! self )
        return nil;
    
    _meeting = meeting;
    _ownCalendar = ownCalendar;
    _anotherCalendar = anotherCalendar;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Meeting"];
    
    // Map position (Creamery with a zoom of 13)
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(37.77737268012564, -122.39515461257294);
    [_mapView setRegion:MKCoordinateRegionMake(centerCoordinate, MKCoordinateSpanMake(180 / pow(2, 13) * _mapView.height / 256, 0)) animated:NO];
    
    // Annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:centerCoordinate];
    [_mapView addAnnotation:annotation];

    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        self.navigationController.navigationBar.hidden = YES;
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ( ! _meeting )
        return;
    
    NSDateFormatter* formatterDate = [[NSDateFormatter alloc] init];
    [formatterDate setDateStyle:NSDateFormatterFullStyle];
    [formatterDate setTimeStyle:NSDateFormatterNoStyle];
    [formatterDate setDoesRelativeDateFormatting:TRUE];
    NSString* dateString = [formatterDate stringFromDate:_meeting.startDate];
    
    NSDateFormatter* formatterTime = [[NSDateFormatter alloc] init];
    [formatterTime setDateStyle:NSDateFormatterNoStyle];
    [formatterTime setTimeStyle:NSDateFormatterShortStyle];
    [formatterTime setDoesRelativeDateFormatting:NO];
    NSString* startTimeString = [formatterTime stringFromDate:_meeting.startDate];
    NSString* endTimeString = [formatterTime stringFromDate:_meeting.endDate];

    _whenLabel.text = [NSString stringWithFormat:@"%@\n%@ to %@", dateString, startTimeString, endTimeString];
}

#pragma mark - Button handlers

- (IBAction)changeTimeTapped:(id)sender {
    WVSCalendarViewController* calendarView = [[WVSCalendarViewController alloc] initWithOwnCalendar:_ownCalendar anotherCalendar:_anotherCalendar andMeeting:_meeting];
    [self.navigationController pushViewController:calendarView animated:YES];
}

- (void)meetingAddedToCalendar
{
    [_activityIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmTapped:(id)sender {
    
    // Loading animation (as for some reason opening calendar view takes time sometimes)
    [_activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    // Note: here should be save call to store the created meeting on backend
    
    // Adding to calendar
    [_meeting addToCalendar:self withTarget:self andSelector:@selector(meetingAddedToCalendar)];
}

@end
