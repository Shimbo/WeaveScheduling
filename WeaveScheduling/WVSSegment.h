//
//  WVSSegment.h
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import <Foundation/Foundation.h>

@interface WVSSegment : NSObject
{
    NSDate* _startDate;
    NSDate* _endDate;
}

@property (atomic, retain) NSDate* startDate;
@property (atomic, retain) NSDate* endDate;

- (id) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
+ (id) segmentWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end