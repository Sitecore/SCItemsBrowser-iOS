#import <Foundation/Foundation.h>
#import <SCItemsBrowser/RequestBuilder/SIBAbstractTemplateListRequestBuilder.h>

/**
 Creates the request to fetch only those children of the given item having the templates from the initializer list.
 */
@interface SIBWhiteListTemplateRequestBuilder : SIBAbstractTemplateListRequestBuilder

/**
 Creates a query based request that fetches children of the given item that match any of the template on the list.
 
 @param sender One of the items browser controllers below.
 * SCItemListBrowser
 * SCItemGridBrowser
 
 @param item The children list should be defined for it by this class.
 
 @return A request that defines the scope of child items.
 */
-(SCItemsReaderRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item;

@end
