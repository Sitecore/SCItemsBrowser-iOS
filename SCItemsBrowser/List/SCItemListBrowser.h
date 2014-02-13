#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsBrowserProtocol.h>
#import <SCItemsBrowser/SCItemsBrowserInitialization.h>

@protocol SIBListModeAppearance;
@protocol SIBListModeCellFactory;


@interface SCItemListBrowser : NSObject<SCItemsBrowserProtocol, SCItemsBrowserInitialization, UITableViewDataSource, UITableViewDelegate>

@property ( nonatomic, weak ) IBOutlet UITableView* tableView;

@property ( nonatomic, strong ) SCExtendedApiContext* apiContext;
@property ( nonatomic, strong ) SCItem*               rootItem  ;
@property ( nonatomic, weak   ) IBOutlet id<SCItemsLevelRequestBuilder> nextLevelRequestBuilder;
@property ( nonatomic, weak   ) IBOutlet id<SCItemsBrowserDelegate> delegate;

@property ( nonatomic, weak   ) IBOutlet id<SIBListModeAppearance> listModeTheme;
@property ( nonatomic, weak   ) IBOutlet id<SIBListModeCellFactory> listModeCellBuilder;

@end
