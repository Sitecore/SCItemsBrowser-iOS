#import <UIKit/UIKit.h>

@class SCItem;
@class SCExtendedApiContext;

@protocol SIBListModeAppearance;
@protocol SIBGridModeAppearance;
@protocol SCItemsBrowserDelegate;


@interface SCItemsBrowserView : UIView

#pragma mark -
#pragma mark Once assign properties
@property ( nonatomic, strong ) IBOutlet SCExtendedApiContext* apiContext;
@property ( nonatomic, strong ) IBOutlet SCItem*               rootItem  ;

@property ( nonatomic, weak   ) IBOutlet id<SIBListModeAppearance> listModeTheme;
@property ( nonatomic, weak   ) IBOutlet id<SIBGridModeAppearance> gridModeTheme;

@property ( nonatomic, weak   ) IBOutlet id<SCItemsBrowserDelegate> delegate;



@end

