#import "GBViewController.h"

#import <SCItemsBrowser/SCItem-Extenstions/SCItem+Media.h>

static NSString* const ROOT_ITEM_PATH = @"/sitecore";

@interface GBViewController ()<SCItemsBrowserDelegate, SIBGridModeAppearance, SIBGridModeCellFactory>

@property (strong, nonatomic) IBOutlet SCItemGridBrowser *itemsBrowserController;
@property (strong, nonatomic) IBOutlet SIBAllChildrenRequestBuilder *allChildrenRequestBuilder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingProgress;
@property (weak, nonatomic) IBOutlet UITextView *itemPathTextView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *itemsBrowserGridLayout;

@property (weak, nonatomic) IBOutlet UIButton *rootButton;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@end

@implementation GBViewController
{
    SCApiSession* _legacyApiSession;
    SCExtendedApiSession* _apiSession;
}

-(void)setupContext
{
    self->_legacyApiSession =
    [ SCApiSession sessionWithHost: @"http://mobiledev1ua1.dk.sitecore.net:7200"
                             login: @"sitecore\\admin"
                          password: @"b"
                           version: SCWebApiMaxSupportedVersion ];
    
    self->_legacyApiSession.defaultDatabase = @"master";
    self->_legacyApiSession.defaultSite = @"/sitecore/shell";
    
    self->_apiSession = self->_legacyApiSession.extendedApiSession;
}

-(void)setupLayout
{
    self.itemsBrowserGridLayout.itemSize = CGSizeMake( 80, 80 );
//    self.itemsBrowserGridLayout.minimumLineSpacing      = 10;
//    self.itemsBrowserGridLayout.minimumInteritemSpacing = 10;
}

-(void)localizeButtons
{
    [ self.rootButton setTitle: NSLocalizedString( @"BTN_GO_TO_ROOT", nil )
forState: UIControlStateNormal ];

    [ self.reloadButton setTitle: NSLocalizedString( @"BTN_FORCE_REFRESH", nil )
                      forState: UIControlStateNormal ];
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    [ self localizeButtons ];
    [ self setupLayout  ];
    
    NSParameterAssert( nil != self.itemsBrowserController );

    [ self setupContext ];
    self.itemsBrowserController.apiSession = self->_apiSession;
    
    
    SCExtendedAsyncOp rootItemLoader =
    [ self->_apiSession readItemOperationForItemPath: ROOT_ITEM_PATH
                                          itemSource: nil ];
    
    [ self startLoading ];
    __weak GBViewController* weakSelf = self;
    rootItemLoader( nil, nil, ^( SCItem* rootItem, NSError* blockError )
    {
       [ weakSelf endLoading ];
       
       if ( nil == rootItem )
       {
           [ weakSelf didFailLoadingRootItemWithError: blockError ];
       }
       else
       {
           [ weakSelf didLoadRootItem: rootItem ];
       }
    } );
}


#pragma mark -
#pragma mark Progress
-(void)startLoading
{
    self.loadingProgress.hidden = NO;
    [ self.loadingProgress startAnimating ];
}

-(void)endLoading
{
    [ self.loadingProgress stopAnimating ];
    self.loadingProgress.hidden = YES;
}

-(void)didFailLoadingRootItemWithError:( NSError* )error
{
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString(@"ALERT_LOAD_ROOT_ITEM_ERROR_TITLE", nil )
                                                       message: error.localizedDescription
                                                      delegate: nil
                                             cancelButtonTitle: NSLocalizedString(@"ALERT_LOAD_ROOT_ITEM_ERROR_CANCEL", nil )
                                             otherButtonTitles: nil ];
    
    [ alert show ];
    [ self endLoading ];
}

-(void)didLoadRootItem:( SCItem* )rootItem
{
    self.itemsBrowserController.rootItem = rootItem;
    
    [ self startLoading ];
    [ self.itemsBrowserController reloadData ];
}


#pragma mark -
#pragma mark ButtonEvents
-(IBAction)onRootButtonTapped:(id)sender
{
    if ( nil == self->_itemsBrowserController.rootItem )
    {
        [ self showCannotGoToRootMessage ];
        return;
    }
    
    [ self startLoading ];
    [ self->_itemsBrowserController navigateToRootItem ];
}

-(IBAction)onReloadButtonTapped:(id)sender
{
    if ( nil == self->_itemsBrowserController.rootItem )
    {
        [ self showCannotReloadMessage ];
        return;
    }
    
    [ self startLoading ];
    [ self->_itemsBrowserController forceRefreshData ];
}

-(void)showCannotGoToRootMessage
{
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString( @"ALERT_GO_TO_ROOT_ITEM_ERROR_TITLE", nil )
                                                       message: NSLocalizedString( @"ALERT_GO_TO_ROOT_ITEM_ERROR_MESSAGE", nil )
                                                      delegate: nil
                                             cancelButtonTitle: NSLocalizedString( @"ALERT_GO_TO_ROOT_ITEM_ERROR_CANCEL", nil )
                                             otherButtonTitles: nil ];
    [ alert show ];
    [ self endLoading ];
}

-(void)showCannotReloadMessage
{
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString( @"ALERT_RELOAD_LEVEL_ERROR_TITLE", nil )
                                                       message: NSLocalizedString( @"ALERT_RELOAD_LEVEL_ERROR_MESSAGE", nil )
                                                      delegate: nil
                                             cancelButtonTitle: NSLocalizedString( @"ALERT_RELOAD_LEVEL_ERROR_CANCEL", nil )
                                             otherButtonTitles: nil ];
    [ alert show ];
    [ self endLoading ];
}

#pragma mark -
#pragma mark SCItemsBrowserDelegate
-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id )progressInfo
{
    [ self startLoading ];
}

-(void)itemsBrowser:( id )sender
levelLoadingFailedWithError:( NSError* )error
{
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString( @"ALERT_LOAD_LEVEL_ERROR_TITLE", nil )
                                                       message: error.localizedDescription
                                                      delegate: nil
                                             cancelButtonTitle: NSLocalizedString(@"ALERT_LOAD_LEVEL_ERROR_CANCEL", nil )
                                             otherButtonTitles: nil ];
    
    [ alert show ];
    [ self endLoading ];
}

-(void)itemsBrowser:( id )sender
didLoadLevelForItem:( SCItem* )levelParentItem
{
    NSParameterAssert( nil != levelParentItem );
    
    [ self endLoading ];
    self.itemPathTextView.text = levelParentItem.path;
    
    
    // leaving this on the user's behalf
    NSIndexPath* top = [ NSIndexPath indexPathForRow: 0
                                           inSection: 0 ];
    
    UICollectionView* collectionView = self->_itemsBrowserController.collectionView;
    [ collectionView scrollToItemAtIndexPath: top
                            atScrollPosition: UICollectionViewScrollPositionTop
                                    animated: NO ];
}

-(BOOL)itemsBrowser:( id )sender
shouldLoadLevelForItem:( SCItem* )levelParentItem
{
    return levelParentItem.isFolder || levelParentItem.hasChildren;
}


#pragma mark -
#pragma mark SIBGridModeCellFactory
static NSString* const LEVEL_UP_CELL_ID  = @"net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell"   ;
static NSString* const ITEM_CELL_ID      = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"      ;
static NSString* const IMAGE_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image";

-(NSString*)levelUpCellReuseId
{
    return LEVEL_UP_CELL_ID;
}

-(NSString*)reuseIdentifierForItem:( SCItem* )item
{
    if ( [ item isMediaImage ] )
    {
        return IMAGE_CELL_ID;
    }
    else
    {
        return ITEM_CELL_ID;
    }
}

-(Class)levelUpCellClass
{
    return [ SCDefaultLevelUpGridCell class ];
}

-(Class)cellClassForItem:( SCItem* )item
{
    if ( [ item isMediaImage ] )
    {
        return [ SCMediaItemGridCell class ];
    }
    else
    {
        return [ SCItemGridTextCell class ];
    }
}

-(UICollectionViewCell*)itemsBrowser:( SCItemGridBrowser* )sender
        createLevelUpCellAtIndexPath:( NSIndexPath* )indexPath
{
    NSString* reuseId = [ self levelUpCellReuseId ];
    Class levelUpCellClass = [ self levelUpCellClass ];
    
    UICollectionView* collectionView = self->_itemsBrowserController.collectionView;
    [ collectionView registerClass: levelUpCellClass
        forCellWithReuseIdentifier: reuseId ];
    
    SCDefaultLevelUpGridCell* result =
    [ collectionView dequeueReusableCellWithReuseIdentifier: reuseId
                                               forIndexPath: indexPath ];
    [ result setLevelUpText: NSLocalizedString( @"CELL_LEVEL_UP_TEXT", @".." ) ];
    [ self setColorsForCell: result ];
    
    return result;
}

-(UICollectionViewCell<SCItemCell>*)itemsBrowser:( SCItemGridBrowser* )sender
                       createGridModeCellForItem:( SCItem* )item
                                     atIndexPath:( NSIndexPath* )indexPath
{
    NSString* reuseId = [ self reuseIdentifierForItem: item ];
    Class levelUpCellClass = [ self cellClassForItem: item ];
    
    UICollectionView* collectionView = self->_itemsBrowserController.collectionView;
    [ collectionView registerClass: levelUpCellClass
        forCellWithReuseIdentifier: reuseId ];
    
    UICollectionViewCell<SCItemCell>* result =
    [ collectionView dequeueReusableCellWithReuseIdentifier: reuseId
                                               forIndexPath: indexPath ];
    [ self setColorsForCell: result ];
    
    return result;
}


#pragma mark -
#pragma mark SIBGridModeAppearance
-(void)setColorsForCell:(UICollectionViewCell*)cell
{
    cell.backgroundColor = [ UIColor greenColor ];
}

-(void)setHighlightColorsForCell:(UICollectionViewCell*)cell
{
    cell.backgroundColor = [ UIColor cyanColor ];
}

-(void)itemsBrowser:( SCItemGridBrowser* )sender
 didUnhighlightCell:( UICollectionViewCell* )cell
            forItem:( SCItem* )item
        atIndexPath:( NSIndexPath* )indexPath
{
    [ self setColorsForCell: cell ];
}

-(void)itemsBrowser:( SCItemGridBrowser* )sender
   didHighlightCell:( UICollectionViewCell* )cell
            forItem:( SCItem* )item
        atIndexPath:( NSIndexPath* )indexPath
{
    [ self setHighlightColorsForCell: cell ];
}

@end
