#import "StubRequestBuilder.h"

@implementation StubRequestBuilder

-(SCReadItemsRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item
{
    return self.requestStub;
}

@end
