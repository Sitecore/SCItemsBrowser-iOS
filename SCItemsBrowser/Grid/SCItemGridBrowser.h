#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <SCItemsBrowser/SCItemsBrowserProtocol.h>
#import <SCItemsBrowser/SCItemsBrowserInitialization.h>

@class SCExtendedApiContext;
@protocol SIBGridModeAppearance;
@protocol SIBGridModeCellFactory;


@interface SCItemGridBrowser : NSObject<SCItemsBrowserProtocol, SCItemsBrowserInitialization, UICollectionViewDataSource, UICollectionViewDelegate>


/**
 A table view to display items. The SCItemGridBrowser controller will become both a delegate and a datasource for it. It can be set from the Interface Builder.
 */
@property ( nonatomic, weak ) IBOutlet UICollectionView* collectionView;

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
@property ( nonatomic, weak   ) IBOutlet id<SIBGridModeAppearance> gridModeTheme;


/**
 A factory that constructs new cells and provides reuse identifiers. It should not invoke tableView:cellForRowAtIndexPath: explicitly since SCItemGridBrowser will do it behind the scenes.
 It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SIBGridModeCellFactory> gridModeCellBuilder;

@end
