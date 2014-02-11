#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsBrowserProtocol.h>
#import <SCItemsBrowser/SCItemsBrowserInitialization.h>

@protocol SIBListModeAppearance;
@protocol SIBListModeCellFactory;


@interface SCItemListBorwser : NSObject<SCItemsBrowserProtocol, SCItemsBrowserInitialization, UITableViewDataSource>

@property ( nonatomic, weak ) IBOutlet UITableView* tableView;

@property ( nonatomic, strong ) IBOutlet SCExtendedApiContext* apiContext;
@property ( nonatomic, strong ) IBOutlet SCItem*               rootItem  ;
@property ( nonatomic, weak   ) IBOutlet id<SCItemsLevelRequestBuilder> nextLevelRequestBuilder;
@property ( nonatomic, weak   ) IBOutlet id<SCItemsBrowserDelegate> delegate;

@property ( nonatomic, weak   ) IBOutlet id<SIBListModeAppearance> listModeTheme;
@property ( nonatomic, weak   ) IBOutlet id<SIBListModeCellFactory> listModeCellBuilder;

@end
