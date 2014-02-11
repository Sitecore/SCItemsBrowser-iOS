#import "SCItemListBorwser.h"

@implementation SCItemListBorwser

#pragma mark -
#pragma mark Once assign properties
-(void)setTableView:( UITableView* )tableView
{
    NSParameterAssert( nil == self->_tableView );
    self->_tableView = tableView;
}

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

-(void)setNextLevelRequestBuilder:(id<SCItemsLevelRequestBuilder>)nextLevelRequestBuilder
{
    NSParameterAssert( nil == self->_nextLevelRequestBuilder );
    self->_nextLevelRequestBuilder = nextLevelRequestBuilder;
}

#pragma mark - 
#pragma mark SCItemsBrowserProtocol
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


#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    NSAssert( NO, @"not implemented" );    
    return NSNotFound;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert( NO, @"not implemented" );
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
