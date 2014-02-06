#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiContext;
@protocol SCItemsLevelRequestBuilder;


typedef void (^OnLevelLoadedBlock)( NSArray* loadedItems, NSError *error );


@interface SCItemsFileManager : NSObject

-(instancetype)initWithApiContext:( SCExtendedApiContext* )apiContext
              levelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder;


-(void)loadLevelForItem:( SCItem* )item
             completion:( OnLevelLoadedBlock )onLevelLoadedBlock
          ignoringCache:( BOOL )shouldIgnoreCache;

@end
