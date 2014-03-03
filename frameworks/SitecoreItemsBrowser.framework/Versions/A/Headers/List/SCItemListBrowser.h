#import <SitecoreItemsBrowser/ItemsBrowser/SCAbstractItemsBrowser.h>
#import <SitecoreItemsBrowser/ItemsBrowser/SCAbstractItemsBrowserSubclassing.h>

#import <SitecoreItemsBrowser/SCItemsBrowserProtocol.h>
#import <SitecoreItemsBrowser/SCItemsBrowserInitialization.h>



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol SIBListModeAppearance;
@protocol SIBListModeCellFactory;

/**
 The SCItemListBrowser class is responsible for displaying items hierarchy in the UITableView object provided by the user. It is a controller in terms of the MVC pattern. The items hierarchy is read-only so the user cannot edit content using this control.
 
 Once initialized, it should be possible to
 
 - reloadData
 - forceRefreshData
 - navigateToRootItem
 
 SCItemListBrowser takes the control over both UITableViewDelegate and UITableViewDataSource events. The user should not set them directly. It does not support some UITableView features.
 
 - Multiple cells selection
 - Cells editing
 - Animated insertion or deletion
 - Accessory views
 

 It is not possible to modify its properties once initialized. If you need to change the root item or api session, a new controller must be created.
 */
@interface SCItemListBrowser : SCAbstractItemsBrowser<SCAbstractItemsBrowserSubclassing, UITableViewDataSource, UITableViewDelegate>

/**
 A table view to display items. The SCItemListBrowser controller will become both a delegate and a datasource for it. It can be set from the Interface Builder.
 */
@property ( nonatomic, weak ) IBOutlet UITableView* tableView;

/**
 A theme class that responds to UITableViewDelegate methods.
 It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SIBListModeAppearance> listModeTheme;


/**
  A factory that constructs new cells and provides reuse identifiers. It should not invoke [UITableViewDataSource tableView:cellForRowAtIndexPath:] explicitly since SCItemListBrowser will do it behind the scenes.
  It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SIBListModeCellFactory> listModeCellBuilder;

@end
