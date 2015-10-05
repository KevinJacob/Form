#import "FORMBackgroundView.h"
#import "FORMDefaultStyle.h"
#import "FORMLayout.h"
#import "FORMLayoutAttributes.h"
#import "UIColor+Hex.h"

static NSString * const FORMGroupBackgroundColorKey = @"background_color";

@interface FORMBackgroundView ()

@end

@implementation FORMBackgroundView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    FORMLayoutAttributes *backgroundLayoutAttributes = (FORMLayoutAttributes *)layoutAttributes;
    self.styles = backgroundLayoutAttributes.styles;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;

    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:corners
                                                              cornerRadii:CGSizeMake(kFormsCornerRadius, kFormsCornerRadius)];
    [rectanglePath closePath];

    [self.groupColor setFill];
    [rectanglePath fill];
}

- (void)setGroupBackgroundColor:(UIColor *)color {
    NSString *style = [self.styles valueForKey:FORMGroupBackgroundColorKey];
    if ([style length] > 0) {
        color = [UIColor colorFromHex:style];
    } else {
        color = [UIColor whiteColor];
    }
    
    self.groupColor = color;
}

@end
