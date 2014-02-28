#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiSession;
@protocol SCItemsLevelRequestBuilder;


@class SCItemsFileManagerCallbacks;


@interface SCItemsFileManager : NSObject

-(instancetype)initWithApiSession:( SCExtendedApiSession* )apiSession
              levelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder;

-(BOOL)isRootLevelLoaded;

-(void)loadLevelForItem:( SCItem* )item
              callbacks:( SCItemsFileManagerCallbacks* )callbacks
          ignoringCache:( BOOL )shouldIgnoreCache;

-(void)reloadCurrentLevelNotifyingCallbacks:( SCItemsFileManagerCallbacks* )callbacks
                              ignoringCache:( BOOL )shouldIgnoreCache;

-(void)goToLevelUpNotifyingCallbacks:( SCItemsFileManagerCallbacks* )callbacks;

@end
