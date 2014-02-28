#import <UIKit/UIKit.h>
#import <SCItemsBrowser/SCItemsBrowserProtocol.h>
#import <SCItemsBrowser/SCItemsBrowserInitialization.h>

@class SCItem;
@class SCExtendedApiSession;

@protocol SCItemsBrowserDelegate;
@protocol SCItemsLevelRequestBuilder;

@protocol SIBListModeAppearance;
@protocol SIBGridModeAppearance;

@protocol SIBListModeCellFactory;
@protocol SIBGridModeCellFactory;



@interface SCItemsBrowserView : UIView<SCItemsBrowserInitialization, SCItemsBrowserProtocol>

#pragma mark -
#pragma mark Once assign properties
@property ( nonatomic, strong ) SCExtendedApiSession* apiContext;
@property ( nonatomic, strong ) SCItem*               rootItem  ;
@property ( nonatomic, weak   ) IBOutlet id<SCItemsLevelRequestBuilder> nextLevelRequestBuilder;

@property ( nonatomic, weak   ) IBOutlet id<SIBListModeAppearance> listModeTheme;
@property ( nonatomic, weak   ) IBOutlet id<SIBGridModeAppearance> gridModeTheme;

@property ( nonatomic, weak   ) IBOutlet id<SIBListModeCellFactory> listModeCellBuilder;
@property ( nonatomic, weak   ) IBOutlet id<SIBGridModeCellFactory> gridModeCellBuilder;

@property ( nonatomic, weak   ) IBOutlet id<SCItemsBrowserDelegate> delegate;

@end

