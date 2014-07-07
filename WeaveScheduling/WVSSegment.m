//
//  WVSSegment.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 7/5/14.
//
//

#import "WVSSegment.h"

@implementation WVSSegment

- (id) initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
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

+ (id) segmentWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    WVSSegment* segment = [[WVSSegment alloc] initWithStartDate:startDate endDate:endDate];
    return segment;
}

@end
