#import "SCItemsFileManager.h"

#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface SCItemsFileManager (UnitTest)

-(SCCancelAsyncOperation)cancelLoaderBlock;
-(void)setCancelLoaderBlock:(SCCancelAsyncOperation)value;

-(SCItemsReaderRequest*)buildLevelRequestForItem:( SCItem* )item
                                   ignoringCache:( BOOL )shouldIgnoreCache;

-(SCExtendedAsyncOp)buildLevelLoaderForItem:( SCItem* )item
                              ignoringCache:( BOOL )shouldIgnoreCache;

@end
