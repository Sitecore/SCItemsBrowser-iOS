#import "SIBAbstractTemplateListRequestBuilder.h"

#import "SCItem+Media.h"

@implementation SIBAbstractTemplateListRequestBuilder

{
    NSArray* _templateNames;
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithTemplateNames:( NSArray* )templateNames
{
    NSParameterAssert( [ templateNames count ] > 0 );
    
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_templateNames = templateNames;
    
    return self;
}

-(NSString*)templateFilterClause
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

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
    NSString* templatesFilter = [ self templateFilterClause ];
    
    SCItemsReaderRequest* result = [ SCItemsReaderRequest new ];
    {
        result.requestType = SCItemReaderRequestQuery;
        result.request     = [ NSString stringWithFormat: @"%@/*[%@]", item.path, templatesFilter ];
        result.scope       = SCItemReaderChildrenScope  ;
    }
   
    [ self setSourceFromItem: item
                   toRequest: result ];

    return result;
}

@end
