#import "SIBBlackListTemplateRequestBuilder.h"

@implementation SIBBlackListTemplateRequestBuilder

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

-(SCItemsReaderRequest*)itemsBrowser:( id )sender
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
        NSString* templateStatement = [ NSString stringWithFormat: @"@@templatename != '%@'", templateName ];
        [ templateStatements addObject: templateStatement ];
    }
    NSString* templatesFilter = [ templateStatements componentsJoinedByString: @" AND " ];
    
    return templatesFilter;
}

@end
