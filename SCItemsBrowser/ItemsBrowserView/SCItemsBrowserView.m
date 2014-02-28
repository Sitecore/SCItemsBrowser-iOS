#import "SCItemsBrowserView.h"

@implementation SCItemsBrowserView

#pragma mark -
#pragma mark Once assign properties
-(void)setApiContext:( SCExtendedApiSession* )value
{
    NSParameterAssert( nil == self->_apiContext );
    self->_apiContext = value;
}

-(void)setRootItem:(SCItem *)rootItem
{
    NSParameterAssert( nil == self->_rootItem );
    self->_rootItem = rootItem;
}

-(void)setListModeTheme:(id<SIBListModeAppearance>)listModeTheme
{
    NSParameterAssert( nil == self->_listModeTheme );
    self->_listModeTheme = listModeTheme;
}

-(void)setGridModeTheme:(id<SIBGridModeAppearance>)gridModeTheme
{
    NSParameterAssert( nil == self->_gridModeTheme );
    self->_gridModeTheme = gridModeTheme;
}

-(void)setDelegate:(id<SCItemsBrowserDelegate>)delegate
{
    NSParameterAssert( nil == self->_delegate );
    self->_delegate = delegate;
}

-(void)setListModeCellBuilder:(id<SIBListModeCellFactory>)listModeCellBuilder
{
    NSParameterAssert( nil == self->_listModeCellBuilder );
    self->_listModeCellBuilder = listModeCellBuilder;
    
}

-(void)setGridModeCellBuilder:(id<SIBGridModeCellFactory>)gridModeCellBuilder
{
    NSParameterAssert( nil == self->_gridModeCellBuilder );
    self->_gridModeCellBuilder = gridModeCellBuilder;
}

-(void)setNextLevelRequestBuilder:(id<SCItemsLevelRequestBuilder>)nextLevelRequestBuilder
{
    NSParameterAssert( nil == self->_nextLevelRequestBuilder );
    self->_nextLevelRequestBuilder = nextLevelRequestBuilder;
}

#pragma mark -
#pragma mark Refresh
-(void)reloadData
{
    NSAssert( NO, @"not implemented" );
}

-(void)forceRefreshData
{
    NSAssert( NO, @"not implemented" );
}

-(void)navigateToRootItem
{
    NSAssert( NO, @"not implemented" );
}

@end
