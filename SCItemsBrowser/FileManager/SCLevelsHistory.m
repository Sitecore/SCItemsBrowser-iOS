#import "SCLevelsHistory.h"

#import "SCLevelInfoPOD.h"

@implementation SCLevelsHistory
{
    NSMutableArray* _levelStorage;
}

-(instancetype)init
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }

    [ self initializeLevelStorage ];

    return self;
}

-(void)initializeLevelStorage
{
    self->_levelStorage = [ NSMutableArray new ];
}

-(void)pushRequest:( SCItemsReaderRequest* )request
           forItem:( SCItem* )item
{
    SCLevelInfoPOD* record = [ [ SCLevelInfoPOD alloc ] initWithLevelRequest: request
                                                                     forItem: item ];
    [ self->_levelStorage addObject: record ];
}

-(SCItemsReaderRequest*)lastRequest
{
    return [ [ self->_levelStorage lastObject ] levelRequest ];
}

-(SCItem*)lastItem
{
    return [ [ self->_levelStorage lastObject ] levelParentItem ];
}

-(void)popRequest
{
    [ self->_levelStorage removeLastObject ];
}

@end
