//
//  LFCCalendarCollectionView.m
//  WeaveScheduling
//
//  Created by Mikhail Larionov on 12/24/13.
//

#import "WVSCalendarCollectionView.h"

#pragma mark - Calendar Collection Cell

@implementation WVSCalendarCollectionCell
@end

#pragma mark - Calendar Collection Layout

@implementation WVSCalendarCollectionLayout

-(id)init {
    self = [super init];
    if (self) {
        self.itemSize = WVSCustomCellSize;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if(proposedContentOffset.x>=self.collectionViewContentSize.width-self.collectionView.width)
        return proposedContentOffset;
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalOffset = proposedContentOffset.x + WVSCustomCellSpacing*UNI_COEF;
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemOffset = layoutAttributes.frame.origin.x;
        if (ABS(itemOffset - horizontalOffset) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemOffset - horizontalOffset;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end

#pragma mark - Calendar Collection View

@implementation WVSCalendarCollectionView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ( [view isKindOfClass:[UIButton class]] )
        return YES;
    return [super touchesShouldCancelInContentView:view];
}

@end
