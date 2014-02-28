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

-(void)pushRequest:( SCReadItemsRequest* )request
           forItem:( SCItem* )item
{
    SCLevelInfoPOD* record = [ [ SCLevelInfoPOD alloc ] initWithLevelRequest: request
                                                                     forItem: item ];
    [ self->_levelStorage addObject: record ];
}

-(void)popRequest
{
    [ self->_levelStorage removeLastObject ];
}

-(NSUInteger)currentLevel
{
    return [ self->_levelStorage count ];
}

-(BOOL)isRootLevelLoaded
{
    return [ self currentLevel ] >= 1;
}

-(BOOL)isLevelUpAvailable
{
    return [ self currentLevel ] >= 2;
}

-(SCReadItemsRequest*)lastRequest
{
    return [ [ self->_levelStorage lastObject ] levelRequest ];
}

-(SCItem*)lastItem
{
    return [ [ self->_levelStorage lastObject ] levelParentItem ];
}

-(SCLevelInfoPOD*)levelUpRecord
{
    if ( ![ self isLevelUpAvailable ] )
    {
        return nil;
    }
    
    NSUInteger levelsCount = [ self currentLevel ];
    NSUInteger index = levelsCount - 2;

    return self->_levelStorage[ index ];
}

-(SCReadItemsRequest*)levelUpRequest
{
    return [ [ self levelUpRecord ] levelRequest ];
}

-(SCItem*)levelUpParentItem
{
    return [ [ self levelUpRecord ] levelParentItem ];
}

@end
