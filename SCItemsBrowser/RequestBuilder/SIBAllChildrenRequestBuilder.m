#import "SIBAllChildrenRequestBuilder.h"

#import "SCItem+Media.h"

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
        result.requestType = SCItemReaderRequestItemPath;
        result.request     = item.path                  ;
        result.scope       = SCItemReaderChildrenScope  ;
    }
    
    [ self setSourceFromItem: item
                   toRequest: result ];

    return result;
}

@end
