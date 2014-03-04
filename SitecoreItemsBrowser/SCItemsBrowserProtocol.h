#import <Foundation/Foundation.h>


/**
 This protocol describes data load methods that should be supported by each viewController.
 */
@protocol SCItemsBrowserProtocol <NSObject>

/**
 Reloads items using default ApiContext settings.
 */
-(void)reloadData;

/**
 Reloads items by activating the SCItemReaderRequestIngnoreCache flag.
 */
-(void)forceRefreshData;


/**
 Loads child items of the root item using default ApiContext settings.
 */
-(void)navigateToRootItem;

@end
