#import "SIBWhiteListTemplateRequestBuilder.h"

@implementation SIBWhiteListTemplateRequestBuilder
{
    NSArray* _templateNames;
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

-(SCItemsReaderRequest*)levelDownRequestForItem:( SCItem* )item
{
    NSMutableArray* templateStatements = [ @[] mutableCopy ];
    for ( NSString* templateName in self->_templateNames )
    {
        NSString* templateStatement = [ NSString stringWithFormat: @"@@templatename = '%@'", templateName ];
        [ templateStatements addObject: templateStatement ];
    }
    NSString* templatesFilter = [ templateStatements componentsJoinedByString: @" OR " ];

    SCItemsReaderRequest* result = [ SCItemsReaderRequest new ];
    {
        result.requestType = SCItemReaderRequestQuery;
        result.request     = [ NSString stringWithFormat: @"%@/*[%@]", item.path, templatesFilter ];
        result.scope       = SCItemReaderChildrenScope  ;
    }
    
    return result;
}


@end
