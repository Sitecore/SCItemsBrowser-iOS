#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsBrowserProtocol.h>
#import <SCItemsBrowser/SCItemsBrowserInitialization.h>

@protocol SIBListModeAppearance;
@protocol SIBListModeCellFactory;

/**
 The SCItemListBrowser class is responsible for displaying items hierarchy in the UITableView object provided by the user. It is a controller in terms of the MVC pattern.
 
 Once initialized, it should be possible to
 * reloadData
 * forceRefreshData
 * navigateToRootItem

 It is not possible to modify its properties once initialized. If you need to change the root item or api context, a new controller must be created.
 */
@interface SCItemListBrowser : NSObject<SCItemsBrowserProtocol, SCItemsBrowserInitialization, UITableViewDataSource, UITableViewDelegate>

/**
 A table view to display items. The SCItemListBrowser controller will become both a delegate and a datasource for it. It can be set from the Interface Builder.
 */
@property ( nonatomic, weak ) IBOutlet UITableView* tableView;

/**
 The context to communicate with the Sitecore instance. It can be set from code only.
 */
@property ( nonatomic, strong ) SCExtendedApiContext* apiContext;

/**
 An item to start browsing with. It can be set from code only.
 */
@property ( nonatomic, strong ) SCItem*               rootItem  ;

/**
 Set this object to perform filtration by template or any other criteria.
 It can be set from the Interface Builder. For default behaviour (getting all children of the item) please use an instance of the SIBAllChildrenRequestBuilder class.
 */
@property ( nonatomic, weak   ) IBOutlet id<SCItemsLevelRequestBuilder> nextLevelRequestBuilder;

/**
 A delegate that gets notifications about levels loading. 
 It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SCItemsBrowserDelegate> delegate;

/**
 A theme class that responds to UITableViewDelegate methods.
 It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SIBListModeAppearance> listModeTheme;


/**
  A factory that constructs new cells and provides reuse identifiers. It should not invoke tableView:cellForRowAtIndexPath: explicitly since SCItemListBrowser will do it behind the scenes.
  It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SIBListModeCellFactory> listModeCellBuilder;

@end
