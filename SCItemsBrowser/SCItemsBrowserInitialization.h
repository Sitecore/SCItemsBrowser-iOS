#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiSession;

@protocol SCItemsBrowserDelegate;
@protocol SCItemsLevelRequestBuilder;


/**
 Basic initialization methods for any items browser controller.
 */
@protocol SCItemsBrowserInitialization <NSObject>


/**
 @return The context to communicate with the Sitecore instance.
 */
-(SCExtendedApiSession*)apiSession;

/**
 @param apiContext The context to communicate with the Sitecore instance.
 */
-(void)setApiSession:( SCExtendedApiSession* )apiSession;


/**
 @return An item to start browsing with.
 */
-(SCItem*)rootItem;

/**
 @param rootItem An item to start browsing with.
 */
-(void)setRootItem:( SCItem* )rootItem;

/**
 @return A factory to build level queries. It can be used to filter items.
*/
 -(id<SCItemsLevelRequestBuilder>)nextLevelRequestBuilder;

/**
 @param nextLevelRequestBuilder A factory to build level queries. It can be used to filter items.
 */
-(void)setNextLevelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder;

/**
 @return A delegate that gets notifications about levels loading.
 */
-(id<SCItemsBrowserDelegate>)delegate;

/**
 @param delegate A delegate that gets notifications about levels loading.
 */
-(void)setDelegate:( id<SCItemsBrowserDelegate> )delegate;

@end
