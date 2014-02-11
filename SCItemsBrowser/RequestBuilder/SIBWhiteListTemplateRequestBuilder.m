#import "SIBWhiteListTemplateRequestBuilder.h"

@implementation SIBWhiteListTemplateRequestBuilder

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
