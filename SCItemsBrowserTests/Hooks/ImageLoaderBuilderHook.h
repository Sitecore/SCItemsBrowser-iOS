#import <Foundation/Foundation.h>

@class SCFieldImageParams;
@class SCExtendedApiContext;

typedef SCExtendedAsyncOp (^ImageLoaderBuilder)( SCExtendedApiContext* blockSelf, NSString* mediaPath, SCFieldImageParams* options );

@interface ImageLoaderBuilderHook : NSObject

-(instancetype)initWithHookImpl:(ImageLoaderBuilder)hookImpl;

-(void)enableHook;
-(void)disableHook;

@end
