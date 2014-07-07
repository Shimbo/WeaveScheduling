//
//  WVSNewMeetingViewController.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/6/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WVSCalendar.h"
#import "WVSCalendarViewController.h"

@interface WVSNewMeetingViewController : UIViewController
{
    IBOutlet UIActivityIndicatorView *_activityIndicator;
    IBOutlet MKMapView *_mapView;
    
    WVSCalendar* _ownCalendar;
    WVSCalendar* _anotherCalendar;
    
    WVSEvent*   _meeting;
    
    IBOutlet UILabel *_whenLabel;
    IBOutlet UILabel *_whereLabel;
}

- (id) initWithOwnCalendar:(WVSCalendar*)ownCalendar anotherCalendar:(WVSCalendar*)anotherCalendar andMeeting:(WVSEvent *)meeting;
- (IBAction)changeTimeTapped:(id)sender;
- (IBAction)confirmTapped:(id)sender;

@end
