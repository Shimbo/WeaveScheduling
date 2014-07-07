//
//  WVSEvent.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSEvent.h"

@implementation WVSEvent

#pragma mark - Initializers

- (instancetype) initWithLocalEvent:(EKEvent*)event
{
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    _location = event.location;
    _title = event.title;
    _startDate = event.startDate;
    _endDate = event.endDate;
    
    return self;
}

- (instancetype) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    if ( ! startDate || ! endDate )
        return nil;
    
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    _startDate = startDate;
    _endDate = endDate;
    
    return self;
}

- (instancetype) initWithNewEvent:(NSDate*)startDate withTitle:(NSString*)title andLocation:(NSString*)location
{
    if ( ! startDate )
        return nil;
    
    // Parent initialization
    self = [super init];
    if (! self)
        return nil;
    
    _startDate = startDate;
    _endDate = [startDate dateByAddingTimeInterval:WVSDefaultMeetingDuration];
    _location = location;
    _title = title;
    
    return self;
}

+ (instancetype) eventWithLocalEvent:(EKEvent*)event
{
    WVSEvent* thisEvent = [[WVSEvent alloc] initWithLocalEvent:event];
    return thisEvent;
}

+ (instancetype) eventWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    WVSEvent* event = [[WVSEvent alloc] initWithStartDate:startDate endDate:endDate];
    return event;
}

+ (instancetype) eventWithNewEvent:(NSDate*)startDate withTitle:(NSString*)title andLocation:(NSString*)location
{
    WVSEvent* event = [[WVSEvent alloc] initWithNewEvent:startDate withTitle:title andLocation:location];
    return event;
}

- (void) addToCalendar:(UIViewController*)parentController withTarget:(id)target andSelector:(SEL)selector
{
    _saveCallbackTarget = target;
    _saveCallbackSelector = selector;
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if ( granted && ! error )
        {
            EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
            event.title     = _title;
            event.location  = _location;
            event.startDate = _startDate;
            event.endDate   = _endDate;
            
            EKEventEditViewController* eventView = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
            [eventView setEventStore:eventStore];
            [eventView setEvent:event];
            
            [parentController presentViewController:eventView animated:YES completion:nil];
            eventView.editViewDelegate = self;
        }
    }];
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController*)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
    
    NSError *error = nil;
    EKEvent *thisEvent = controller.event;
    
    switch (action) {
        case EKEventEditViewActionCanceled:
            break;
            
        case EKEventEditViewActionSaved:
            [controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            break;
            
        case EKEventEditViewActionDeleted:
            [controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
            break;
            
        default:
            break;
    }
    // Dismiss the modal view controller
    [controller dismissViewControllerAnimated:YES completion:^{
        if ( _saveCallbackTarget && _saveCallbackSelector )
        {
            SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(
                [_saveCallbackTarget performSelector:_saveCallbackSelector]; );
        }
    }];
}

@end
