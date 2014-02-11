#import "SIBBlackListTemplateRequestBuilder.h"

@implementation SIBBlackListTemplateRequestBuilder

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
