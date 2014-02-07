#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsBrowser.h>

@class SCItemsReaderRequest;

@interface StubRequestBuilder : NSObject<SCItemsLevelRequestBuilder>

@property ( nonatomic ) SCItemsReaderRequest* requestStub;

@end
