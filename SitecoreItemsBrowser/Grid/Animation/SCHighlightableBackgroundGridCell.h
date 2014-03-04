#import <Foundation/Foundation.h>

@class UIColor;

@protocol SCHighlightableBackgroundGridCell <NSObject>

-(UIColor*)backgroundColorForNormalState;
-(UIColor*)backgroundColorForHighlightedState;

-(void)setBackgroundColorForNormalState:( UIColor* )value;
-(void)setBackgroundColorForHighlightedState:( UIColor* )value;

@end
