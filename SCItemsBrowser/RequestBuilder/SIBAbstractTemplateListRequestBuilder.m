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
   
    SCItemSourcePOD* src = [ item recordItemSource ];
    {
        result.database = src.database;
        result.language = src.language;
        result.site     = src.site    ;
    }

    return result;
}

@end
