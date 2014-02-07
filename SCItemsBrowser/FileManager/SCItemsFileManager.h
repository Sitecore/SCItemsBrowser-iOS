#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiContext;
@protocol SCItemsLevelRequestBuilder;


@class SCItemsFileManagerCallbacks;


@interface SCItemsFileManager : NSObject

-(instancetype)initWithApiContext:( SCExtendedApiContext* )apiContext
              levelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder;


-(void)loadLevelForItem:( SCItem* )item
              callbacks:( SCItemsFileManagerCallbacks* )callbacks
          ignoringCache:( BOOL )shouldIgnoreCache;

-(void)goToLevelUpNotifyingCallbacks:( SCItemsFileManagerCallbacks* )callbacks;

@end
