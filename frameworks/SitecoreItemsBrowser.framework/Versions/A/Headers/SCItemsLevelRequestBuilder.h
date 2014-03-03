#import <Foundation/Foundation.h>

@class SCItem;
@class SCReadItemsRequest;

/**
 This protocol is used to define parent-child relationships for the items being browsed.
 
 The most often case is filtering by template and plain parent-child concepts usage.
 They are represented by the classes below
 
 - SIBAllChildrenRequestBuilder
 - SIBWhiteListTemplateRequestBuilder
 - SIBBlackListTemplateRequestBuilder
 
 */
@protocol SCItemsLevelRequestBuilder <NSObject>

/**
 Override this method to set the parent-child or filtering relationships for the items being browsed.
 
 @param sender One of the items browser controllers below.
 
 - SCItemListBrowser
 - SCItemGridBrowser
 
 @param item The children list should be defined for it by this class.
 
 @return A request that defines the scope of child items.
 */
-(SCReadItemsRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item;

@end
