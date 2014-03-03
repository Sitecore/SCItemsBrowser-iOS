#import "SIBWhiteListTemplateRequestBuilder.h"

@implementation SIBWhiteListTemplateRequestBuilder

-(instancetype)init
{
    // @adk : required for proper appledoc generation
    
    return [ super init ];
}

-(instancetype)initWithTemplateNames:( NSArray* )templateNames
{
    // @adk : required for proper appledoc generation
    
    return [ super initWithTemplateNames: templateNames ];
}

-(SCReadItemsRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item
{
    // @adk : required for proper appledoc generation
    
    return [ super itemsBrowser: sender
        levelDownRequestForItem: item ];
}

-(NSString*)templateFilterClause
{
    NSMutableArray* templateStatements = [ @[] mutableCopy ];
    for ( NSString* templateName in self.templateNames )
    {
        NSString* templateStatement = [ NSString stringWithFormat: @"@@templatename = '%@'", templateName ];
        [ templateStatements addObject: templateStatement ];
    }
    NSString* templatesFilter = [ templateStatements componentsJoinedByString: @" OR " ];

    return templatesFilter;
}

@end
