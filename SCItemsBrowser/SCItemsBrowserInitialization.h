#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiContext;

@protocol SCItemsBrowserDelegate;
@protocol SCItemsLevelRequestBuilder;


/**
 Basic initialization methods for any items browser controller.
 */
@protocol SCItemsBrowserInitialization <NSObject>


/**
 @return The context to communicate with the Sitecore instance.
 */
-(SCExtendedApiContext*)apiContext;

/**
 @param apiContext : The context to communicate with the Sitecore instance.
 */
-(void)setApiContext:( SCExtendedApiContext* )apiContext;


/**
 @return An item to start browsing with.
 */
-(SCItem*)rootItem;

/**
 @param rootItem : An item to start browsing with.
 */
-(void)setRootItem:( SCItem* )rootItem;

-(id<SCItemsLevelRequestBuilder>)nextLevelRequestBuilder;
-(void)setNextLevelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder;

-(id<SCItemsBrowserDelegate>)delegate;
-(void)setDelegate:( id<SCItemsBrowserDelegate> )delegate;

@end
