#import <Foundation/Foundation.h>
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@class SCLevelResponse;

typedef void (^OnLevelLoadedBlock)( SCLevelResponse* loadedItems, NSError *error );
typedef void (^OnLevelProgressBlock)(id progressInfo);


@interface SCItemsFileManagerCallbacks : NSObject

@property ( nonatomic, copy ) OnLevelLoadedBlock   onLevelLoadedBlock;
@property ( nonatomic, copy ) OnLevelProgressBlock onLevelProgressBlock;
@property ( nonatomic, copy ) SCExtendedOpChainUnit asyncSortDownloadedItemsMonad;

@end
