#import <Foundation/Foundation.h>

typedef SCExtendedAsyncOp (^LevelOperationFromRequestBuilder)( SCItemsReaderRequest* request );

@interface ItemsLevelOperationBuilderHook : NSObject

-(instancetype)initWithHookImpl:(LevelOperationFromRequestBuilder)hookImpl;

-(void)enableHook;
-(void)disableHook;

@end
