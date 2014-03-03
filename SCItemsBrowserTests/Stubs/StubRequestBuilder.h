#import <Foundation/Foundation.h>
#import <SitecoreItemsBrowser/SCItemsBrowser.h>

@class SCReadItemsRequest;

@interface StubRequestBuilder : NSObject<SCItemsLevelRequestBuilder>

@property ( nonatomic ) SCReadItemsRequest* requestStub;

@end
