#import "SIBAllChildrenRequestBuilder.h"

#import "SCItem+Media.h"

@implementation SIBAllChildrenRequestBuilder

-(void)setSourceFromItem:( SCItem* )item
               toRequest:( SCItemsReaderRequest* )outRequest
{
    SCItemSourcePOD* src = [ item recordItemSource ];
    {
        outRequest.database = src.database;
        outRequest.language = src.language;
        outRequest.site     = src.site    ;
    }
}

-(SCItemsReaderRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item
{
    SCItemsReaderRequest* result = [ SCItemsReaderRequest new ];
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
