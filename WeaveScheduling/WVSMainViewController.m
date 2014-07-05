//
//  WVSMainViewController.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSMainViewController.h"

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
    WVSCalendar* calendar = [WVSCalendar calendarWithLocalEvents];
    if ( ! calendar )
    {
        NSLog(@"Error: local events load failed");
        return;
    }
    
    NSDictionary* dictionaryToSave = [calendar toDictionary];
    if ( ! dictionaryToSave )
        return;
    
    [currentUser setObject:dictionaryToSave forKey:@"calendar"];
    [currentUser saveInBackground];
}

- (void) loadStubCalendar
{
    PFUser* stubUser = [PFUser objectWithoutDataWithObjectId:@"GyraPxATkm"];
    [stubUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        NSDictionary* calendarData = [object objectForKey:@"calendar"];
        _stubUserCalendar = [WVSCalendar calendarWithDictionary:calendarData];
    }];
}

@end
