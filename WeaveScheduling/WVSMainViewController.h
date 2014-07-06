//
//  WVSMainViewController.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <UIKit/UIKit.h>
#import "WVSCalendar.h"

@interface WVSMainViewController : UIViewController
{
    WVSCalendar* _currentUserCalendar;
    WVSCalendar* _stubUserCalendar;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
}

- (IBAction)createMeetingTapped:(id)sender;

@end
