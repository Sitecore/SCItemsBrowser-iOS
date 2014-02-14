#import "SIBAllChildrenRequestBuilder.h"

@implementation SIBAllChildrenRequestBuilder

-(SCItemsReaderRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item
{
    SCItemsReaderRequest* result = [ SCItemsReaderRequest new ];
    {
        result.requestType = SCItemReaderRequestItemPath;
        result.request     = item.path                  ;
        result.scope       = SCItemReaderChildrenScope  ;
    }

    return result;
}

@end
