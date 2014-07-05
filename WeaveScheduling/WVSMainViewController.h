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
    WVSCalendar* _stubUserCalendar;
}

- (IBAction)createMeetingTapped:(id)sender;

@end
