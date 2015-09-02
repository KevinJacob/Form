#import "FORMBackgroundView.h"
#import "FORMDefaultStyle.h"

@interface FORMBackgroundView ()

@end

@implementation FORMBackgroundView

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    UIRectCorner corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;

    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                        byRoundingCorners:corners
                                                              cornerRadii:CGSizeMake(kFormsCornerRadius, kFormsCornerRadius)];
    [rectanglePath closePath];

    [[UIColor whiteColor] setFill];
    [rectanglePath fill];
}

@end
