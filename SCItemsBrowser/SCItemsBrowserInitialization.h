#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiContext;

@protocol SCItemsBrowserDelegate;
@protocol SCItemsLevelRequestBuilder;


@protocol SCItemsBrowserInitialization <NSObject>

-(SCExtendedApiContext*)apiContext;
-(void)setApiContext:( SCExtendedApiContext* )apiContext;


-(SCItem*)rootItem;
-(void)setRootItem:( SCItem* )rootItem;

-(id<SCItemsLevelRequestBuilder>)nextLevelRequestBuilder;
-(void)setNextLevelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder;

-(id<SCItemsBrowserDelegate>)delegate;
-(void)setDelegate:( id<SCItemsBrowserDelegate> )delegate;

@end
