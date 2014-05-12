#import <Foundation/Foundation.h>

typedef SCExtendedAsyncOp (^LevelOperationFromRequestBuilder)( SCReadItemsRequest* request );


@interface ItemsLevelOperationBuilderHook : NSObject

-(instancetype)initWithHookImpl:(LevelOperationFromRequestBuilder)hookImpl;

-(void)enableHook;
-(void)disableHook;

@end
