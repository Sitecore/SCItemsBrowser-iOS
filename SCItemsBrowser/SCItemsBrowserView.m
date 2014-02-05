#import "SCItemsBrowserView.h"

@implementation SCItemsBrowserView

-(void)setApiContext:( SCExtendedApiContext* )value
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

@end
