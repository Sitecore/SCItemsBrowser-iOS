#import "StubRequestBuilder.h"

@implementation StubRequestBuilder

-(SCItemsReaderRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item
{
    return self.requestStub;
}

@end
