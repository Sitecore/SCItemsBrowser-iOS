#import "SCItemGridBrowser.h"

#import "SIBGridModeCellFactory.h"
#import "SCLevelUpItem.h"

#import "SIBGridModeAppearance.h"
#import "SCItemsBrowserDelegate.h"

#import "SCAbstractItemsBrowser_Protected.h"

@implementation SCItemGridBrowser

-(void)dealloc
{
    // @adk : this is required since properties are "assign"
    self->_collectionView.delegate   = nil;
    self->_collectionView.dataSource = nil;
}

#pragma mark -
#pragma mark Once assign properties
-(void)setCollectionView:(UICollectionView *)collectionView
{
    NSParameterAssert( nil == self->_collectionView );
    self->_collectionView = collectionView;
    self->_collectionView.dataSource = self;
    self->_collectionView.delegate   = self;
}

-(void)setGridModeTheme:( id<SIBGridModeAppearance> )gridModeTheme
{
    NSParameterAssert( nil == self->_gridModeTheme );
    self->_gridModeTheme = gridModeTheme;
}

-(void)setGridModeCellBuilder:( id<SIBGridModeCellFactory> )gridModeCellBuilder
{
    NSParameterAssert( nil == self->_gridModeCellBuilder );
    self->_gridModeCellBuilder = gridModeCellBuilder;
    
}

#pragma mark -
#pragma mark Override
-(void)reloadContentView
{
    [ self.collectionView reloadData ];
}

-(void)reloadDataIgnoringCache:( BOOL )shouldIgnoreCache
{
    NSParameterAssert( nil != self->_collectionView  );
    
    [ super reloadDataIgnoringCache: shouldIgnoreCache ];
}

#pragma mark - 
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:( UICollectionView* )collectionView
{
    return 1;
}

-(NSInteger)collectionView:( UICollectionView* )collectionView
    numberOfItemsInSection:( NSInteger )section
{
    if ( nil == [ self loadedLevel ] )
    {
        return 0;
    }
    
    NSUInteger result = [ self.loadedLevel.levelContentItems count ];
    return static_cast<NSInteger>( result );
}

-(UICollectionViewCell*)collectionView:( UICollectionView* )collectionView
                cellForItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self.loadedLevel                   );
    NSParameterAssert( nil != self.loadedLevel.levelParentItem   );
    NSParameterAssert( nil != self.loadedLevel.levelContentItems );
    
    NSUInteger cellIndex = static_cast<NSUInteger>( indexPath.row );
    id itemObject = self.loadedLevel.levelContentItems[cellIndex];
    BOOL isLevelUpItem = [ itemObject isMemberOfClass: [ SCLevelUpItem class ] ];
  
    UICollectionViewCell* result = nil;
    if ( isLevelUpItem )
    {
        // calls
        // registerClass:forCellWithReuseIdentifier:
        // dequeueReusableCellWithReuseIdentifier:forIndexPath:
        result = [ self.gridModeCellBuilder itemsBrowser: self
                            createLevelUpCellAtIndexPath: indexPath ];
    }
    else
    {
        // calls
        // registerClass:forCellWithReuseIdentifier:
        // dequeueReusableCellWithReuseIdentifier:forIndexPath:
        NSParameterAssert( [ itemObject isMemberOfClass: [ SCItem class ] ] );
        SCItem* item = (SCItem*)itemObject;
        
        UICollectionViewCell<SCItemCell>* cell =
        [ self.gridModeCellBuilder itemsBrowser: self
                      createGridModeCellForItem: item
                                    atIndexPath: indexPath ];
        
        [ cell setModel: itemObject ];
        [ cell reloadData ];
        
        result = cell;
    }
    
    return result;
}


#pragma mark -
#pragma mark UICollectionViewDelegate
- (BOOL)collectionView:( UICollectionView* )collectionView
shouldSelectItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSUInteger itemIndex = static_cast<NSUInteger>( indexPath.row );
    id itemObject = self.loadedLevel.levelContentItems[itemIndex];
    BOOL isLevelUpItem = [ itemObject isMemberOfClass: [ SCLevelUpItem class ] ];
    
    if ( isLevelUpItem )
    {
        return YES;
    }
    else
    {
        NSParameterAssert( [ itemObject isMemberOfClass: [ SCItem class ] ] );
        SCItem* item = (SCItem*)itemObject;

        return [ self.delegate itemsBrowser: self
                     shouldLoadLevelForItem: item ];
    }
}

-(void)collectionView:( UICollectionView* )collectionView
didSelectItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    id selectedItem = self.loadedLevel.levelContentItems[ selectedItemIndex ];

    [ self didSelectItem: selectedItem
             atIndexPath: indexPath ];
}


#pragma mark -
#pragma mark Appearance
-(void)collectionView:( UICollectionView* )collectionView
didHighlightItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self.loadedLevel );
    NSParameterAssert( nil != indexPath );
    NSParameterAssert( nil != collectionView );
    
    SEL delegateSelector = @selector( itemsBrowser:didHighlightCell:forItem:atIndexPath: );
    if ( ![ self.gridModeTheme respondsToSelector: delegateSelector ]  )
    {
        return;
    }

    
    UICollectionViewCell* cell = [ self.collectionView cellForItemAtIndexPath: indexPath ];
    NSParameterAssert( nil != cell );
    
    
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    SCItem* selectedItem = self.loadedLevel.levelContentItems[selectedItemIndex];
    NSParameterAssert( nil != selectedItem );
    
    [ self.gridModeTheme itemsBrowser: self
                     didHighlightCell: cell
                              forItem: selectedItem
                          atIndexPath: indexPath ];
}

-(void)collectionView:( UICollectionView* )collectionView
didUnhighlightItemAtIndexPath:( NSIndexPath* )indexPath
{
    NSParameterAssert( nil != self.loadedLevel );
    NSParameterAssert( nil != indexPath );
    NSParameterAssert( nil != collectionView );
 
    SEL delegateSelector = @selector( itemsBrowser:didUnhighlightCell:forItem:atIndexPath: );
    if ( ![ self.gridModeTheme respondsToSelector: delegateSelector ]  )
    {
        return;
    }
    
    UICollectionViewCell* cell = [ self.collectionView cellForItemAtIndexPath: indexPath ];
    NSParameterAssert( nil != cell );
    
    NSUInteger selectedItemIndex = static_cast<NSUInteger>( indexPath.row );
    SCItem* selectedItem = self.loadedLevel.levelContentItems[selectedItemIndex];
    NSParameterAssert( nil != selectedItem );
    
    [ self.gridModeTheme itemsBrowser: self
                   didUnhighlightCell: cell
                              forItem: selectedItem
                          atIndexPath: indexPath ];
}

-(UICollectionViewTransitionLayout *)collectionView:( UICollectionView* )collectionView
                       transitionLayoutForOldLayout:( UICollectionViewLayout* )fromLayout
                                          newLayout:( UICollectionViewLayout* )toLayout
{
    SEL delegateSelector = @selector( collectionView:transitionLayoutForOldLayout:newLayout: );
    if ( ![ self.gridModeTheme respondsToSelector: delegateSelector ]  )
    {
        return nil;
    }
    
    return [ self.gridModeTheme itemsBrowser: self
                transitionLayoutForOldLayout: fromLayout
                                   newLayout: toLayout ];
}



@end
