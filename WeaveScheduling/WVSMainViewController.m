//
//  WVSMainViewController.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSMainViewController.h"
#import "WVSCalendarViewController.h"
#import "WVSNewMeetingViewController.h"

@implementation WVSMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor colorWithHexString:@"e8e6e6"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get access rights to the calendar
    [self getAccessToCalendar];
    
    // Load stub user calendar
    [self loadStubCalendar];
}

- (IBAction)createMeetingTapped:(id)sender {
    
    if ( ! _stubUserCalendar )
        return;
    
    WVSCalendarViewController* calendarView = [[WVSCalendarViewController alloc] initWithOwnCalendar:_currentUserCalendar anotherCalendar:_stubUserCalendar andMeeting:nil];
    [self.navigationController pushViewController:calendarView animated:YES];
}

#pragma mark - Save/load logic

- (void) getAccessToCalendar
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
    {
        if (!granted)
            NSLog(@"Error: access to event store was not granted");
        else
            [self saveCurrentCalendar];
    }];
}

- (void) saveCurrentCalendar
{
    // Saving current user's calendar so others will be able to find matching time slots
    _currentUserCalendar = [WVSCalendar calendarWithLocalEvents];
    if ( ! _currentUserCalendar )
    {
        NSLog(@"Error: local events load failed");
        return;
    }
    
    NSDictionary* dictionaryToSave = [_currentUserCalendar toDictionary];
    if ( ! dictionaryToSave )
        return;
    
    [currentUser setObject:dictionaryToSave forKey:@"calendar"];
    [currentUser saveInBackground];
}

- (void) loadStubCalendar
{
    [_activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    PFUser* stubUser = [PFUser objectWithoutDataWithObjectId:@"GyraPxATkm"];
    [stubUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if ( object && ! error )
        {
            NSDictionary* calendarData = [object objectForKey:@"calendar"];
            _stubUserCalendar = [WVSCalendar calendarWithDictionary:calendarData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet" message:@"Loading failed. Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [_activityIndicator stopAnimating];
        self.view.userInteractionEnabled = YES;
    }];
}

@end
