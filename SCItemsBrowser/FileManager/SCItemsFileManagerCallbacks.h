#import <Foundation/Foundation.h>

typedef void (^OnLevelLoadedBlock)( NSArray* loadedItems, NSError *error );

@interface SCItemsFileManagerCallbacks : NSObject

@property ( nonatomic, copy ) OnLevelLoadedBlock onLevelLoadedBlock;

@end
