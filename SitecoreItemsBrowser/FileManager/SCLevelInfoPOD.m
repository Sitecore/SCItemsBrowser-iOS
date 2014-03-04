#import "SCLevelInfoPOD.h"

@implementation SCLevelInfoPOD


-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithLevelRequest:( SCItemsReaderRequest* )levelRequest
                            forItem:( SCItem* )item
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_levelParentItem = item        ;
    self->_levelRequest    = levelRequest;
    
    return self;
}


@end
