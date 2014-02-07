#import "SCItemsFileManager.h"

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@class SCLevelsHistory;

@interface SCItemsFileManager (UnitTest)

-(SCCancelAsyncOperation)cancelLoaderBlock;

-(SCLevelsHistory*)levelsHistory;
-(void)setCancelLoaderBlock:(SCCancelAsyncOperation)value;

-(SCItemsReaderRequest*)buildLevelRequestForItem:( SCItem* )item
                                   ignoringCache:( BOOL )shouldIgnoreCache;

@end
