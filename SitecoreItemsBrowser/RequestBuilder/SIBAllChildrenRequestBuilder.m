#import "SIBAllChildrenRequestBuilder.h"



@implementation SIBAllChildrenRequestBuilder

-(void)setSourceFromItem:( SCItem* )item
               toRequest:( SCReadItemsRequest* )outRequest
{
    SCItemSourcePOD* src = [ item recordItemSource ];
    {
        outRequest.database = src.database;
        outRequest.language = src.language;
        outRequest.site     = src.site    ;
    }
}

-(SCReadItemsRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item
{
    SCReadItemsRequest* result = [ SCReadItemsRequest new ];
    {
        result.requestType = SCReadItemRequestItemPath;
        result.request     = item.path                ;
        result.scope       = SCReadItemChildrenScope  ;
    }
    
    [ self setSourceFromItem: item
                   toRequest: result ];

    return result;
}

@end
