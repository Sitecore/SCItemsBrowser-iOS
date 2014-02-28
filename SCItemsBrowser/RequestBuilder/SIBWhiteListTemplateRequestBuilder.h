#import <Foundation/Foundation.h>
#import <SCItemsBrowser/RequestBuilder/SIBAbstractTemplateListRequestBuilder.h>

/**
 Creates the request to fetch only those children of the given item having the templates from the initializer list.
 */
@interface SIBWhiteListTemplateRequestBuilder : SIBAbstractTemplateListRequestBuilder

/**
 Unsupported initializer. It throws an exception when called.
 Use initWithTemplateNames: instead.
 */
-(instancetype)init;

/**
 Designated initializer.
 
 @param templateNames Names of templates for filtering. Do not include full path entries.
 For example,
 [ [ SIBAbstractTemplateListRequestBuilder alloc ] initWithTemplateNames: @[ @"Folder", @"Item", @"Image" ] ];
 
 @return A properly initialized filter.
 */
-(instancetype)initWithTemplateNames:( NSArray* )templateNames;


/**
 Creates a query based request that fetches children of the given item that match any of the template on the list.
 
 @param sender One of the items browser controllers below.
 * SCItemListBrowser
 * SCItemGridBrowser
 
 @param item The children list should be defined for it by this class.
 
 @return A request that defines the scope of child items.
 */
-(SCReadItemsRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item;

@end
