#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

@class SCReadItemsRequest;

@interface StubRequestBuilder : NSObject<SCItemsLevelRequestBuilder>

@property ( nonatomic ) SCReadItemsRequest* requestStub;

@end
