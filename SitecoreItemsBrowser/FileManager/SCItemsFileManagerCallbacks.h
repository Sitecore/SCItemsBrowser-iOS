#import <Foundation/Foundation.h>


@class SCLevelResponse;

typedef void (^OnLevelLoadedBlock)( SCLevelResponse* loadedItems, NSError *error );
typedef void (^OnLevelProgressBlock)(id progressInfo);


@interface SCItemsFileManagerCallbacks : NSObject


@property ( nonatomic, copy ) OnLevelLoadedBlock   onLevelLoadedBlock;
@property ( nonatomic, copy ) OnLevelProgressBlock onLevelProgressBlock;

@end
