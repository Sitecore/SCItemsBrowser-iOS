#import <Foundation/Foundation.h>
#import <SitecoreItemsBrowser/SCItemsBrowser.h>

@class SCItemsReaderRequest;

@interface StubRequestBuilder : NSObject<SCItemsLevelRequestBuilder>

@property ( nonatomic ) SCItemsReaderRequest* requestStub;

@end
