#import <Foundation/Foundation.h>

/**
 Implement this protocol to receive items browsing events from the controller.
 */
@protocol SCItemsBrowserDelegate <NSObject>

/**
 This event is called whenever some event in request processing occurs. For example, 
 
 - HTTP request has been sent
 - HTTP response has neen received
 - Responce has been cached
 - etc.
 
 @param sender One of the items browser controllers below.
 * SCItemListBrowser 
 * SCItemGridBrowser

 @param progressInfo At the moment there is no single class that holds the progress information. To be defined...
 */
-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id )progressInfo;

/**
 This method is called when a given level has failed to load.
 
 @param sender One of the items browser controllers below.
 
 - SCItemListBrowser
 - SCItemGridBrowser

 @param error An error object received from the Mobile SDK.
 */
-(void)itemsBrowser:( id )sender
levelLoadingFailedWithError:( NSError* )error;

/**
 This method is called to determine whether the browser should navigate down for this item.
 You can use it either to restrict the user from not seeing some branches of the content tree or to define some custom parent-child item relationships.
 
 @param sender One of the items browser controllers below.
 
 - SCItemListBrowser
 - SCItemGridBrowser
 
 @param levelParentItem An item selected by the user.
 
 @return YES if the item is considered to have child items.
 */
-(BOOL)itemsBrowser:( id )sender
shouldLoadLevelForItem:( SCItem* )levelParentItem;

/**
 This method notifies about successful level load for the item selected by the user.
 
 @param sender One of the items browser controllers below.

 - SCItemListBrowser
 - SCItemGridBrowser
 
 @param levelParentItem The root of a successfully loaded level of items.
 */
-(void)itemsBrowser:( id )sender
didLoadLevelForItem:( SCItem* )levelParentItem;

@optional

/**
 This method should provide comparator to sort items list recived from server. Return nil if no sorting needed.
 
 @param sender One of the items browser controllers below.
 
 - SCItemListBrowser
 - SCItemGridBrowser
*/
-(NSComparator)sortResultComparatorForItemsBrowser:( id )sender;

@end
