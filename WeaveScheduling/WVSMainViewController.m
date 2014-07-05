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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)createMeetingTapped:(id)sender {
}
@end
