#import <SitecoreItemsBrowser/ItemsBrowser/SCAbstractItemsBrowser.h>
#import <SitecoreItemsBrowser/ItemsBrowser/SCAbstractItemsBrowserSubclassing.h>

#import <SitecoreItemsBrowser/SCItemsBrowserProtocol.h>
#import <SitecoreItemsBrowser/SCItemsBrowserInitialization.h>


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@class SCExtendedApiSession;
@protocol SIBGridModeAppearance;
@protocol SIBGridModeCellFactory;

/**
 The SCItemGridBrowser class is responsible for displaying items hierarchy in the UICollectionView object provided by the user. It is a controller in terms of the MVC pattern. The items hierarchy is read-only so the user cannot edit content using this control.
 
 Once initialized, it should be possible to
 
 - reloadData
 - forceRefreshData
 - navigateToRootItem
 
 The controller takes the control over both UICollectionViewDelegate and UICollectionViewDataSource events. The user should not set them directly. Still, the user can set any layout of his choice.
 
 SCItemGridBrowser does not support some UICollectionView features.
 
 - Cell menus
 - Multiple cells selection
 - Cells editing
 - Animated insertion or deletion
 - Supplementary views
 
 
 It is not possible to modify its properties once initialized. If you need to change the root item or api session, a new controller must be created.
 */
@interface SCItemGridBrowser : SCAbstractItemsBrowser<SCAbstractItemsBrowserSubclassing, UICollectionViewDataSource, UICollectionViewDelegate>


/**
 A table view to display items. The SCItemGridBrowser controller will become both a delegate and a datasource for it. It can be set from the Interface Builder.
 */
@property ( nonatomic, weak ) IBOutlet UICollectionView* collectionView;


/**
 A theme class that responds to UITableViewDelegate methods.
 It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SIBGridModeAppearance> gridModeTheme;


/**
 A factory that provides cells for various items. The user is responsible for registering cell classes and nib files using the methods below : 
 
 - [UICollectionView registerClass:forCellWithReuseIdentifier:]
 - [UICollectionView registerNib:forCellWithReuseIdentifier:]
 
 The user is also responsible for calling the [UICollectionView dequeueReusableCellWithReuseIdentifier:forIndexPath:] to obtain the cell object. This approach ensures the best possible flexibility since items with different templates may have completely different cells.

 It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SIBGridModeCellFactory> gridModeCellBuilder;

@end
