#import "SCLevelResponse.h"

@implementation SCLevelResponse

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithItem:( SCItem* )levelParentItem
          levelContentItems:( NSArray* )levelContentItems
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    self->_levelParentItem   = levelParentItem  ;
    self->_levelContentItems = levelContentItems;

    return self;
}

@end
