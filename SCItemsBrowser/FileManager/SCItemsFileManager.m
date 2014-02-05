#import "SCItemsFileManager.h"

@implementation SCItemsFileManager
{
    SCExtendedApiContext*          _apiContext;
    id<SCItemsLevelRequestBuilder> _nextLevelRequestBuilder;
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithApiContext:( SCExtendedApiContext* )apiContext
              levelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder
{
    NSParameterAssert( nil != apiContext );
    NSParameterAssert( nil != nextLevelRequestBuilder );
    
    self = [ super init ];
    
    if ( nil == self )
    {
        return nil;
    }
    
    self->_apiContext = apiContext;
    self->_nextLevelRequestBuilder = nextLevelRequestBuilder;
    
    return nil;
}

@end
