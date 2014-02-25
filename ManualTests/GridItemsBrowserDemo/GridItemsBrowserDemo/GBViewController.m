#import "GBViewController.h"

#import <SCItemsBrowser/SCItem-Extenstions/SCItem+Media.h>

static NSString* const ROOT_ITEM_PATH = @"/sitecore";

@interface GBViewController ()<SCItemsBrowserDelegate, SIBGridModeAppearance, SIBGridModeCellFactory>

@property (strong, nonatomic) IBOutlet SCItemGridBrowser *itemsBrowserController;
@property (strong, nonatomic) IBOutlet SIBAllChildrenRequestBuilder *allChildrenRequestBuilder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingProgress;
@property (weak, nonatomic) IBOutlet UITextView *itemPathTextView;

@end

@implementation GBViewController
{
    SCApiContext* _legacyApiContext;
    SCExtendedApiContext* _apiContext;
}

-(void)setupContext
{
    self->_legacyApiContext =
    [ SCApiContext contextWithHost: @"http://mobiledev1ua1.dk.sitecore.net:7200"
                             login: @"sitecore\\admin"
                          password: @"b"
                           version: SCWebApiMaxSupportedVersion ];
    
    self->_legacyApiContext.defaultDatabase = @"master";
    self->_legacyApiContext.defaultSite = @"/sitecore/shell";
    
    self->_apiContext = self->_legacyApiContext.extendedApiContext;
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    NSParameterAssert( nil != self.itemsBrowserController );
    
    [ self setupContext ];
    self.itemsBrowserController.apiContext = self->_apiContext;
    
    
    SCExtendedAsyncOp rootItemLoader =
    [ self->_apiContext itemReaderForItemPath: ROOT_ITEM_PATH
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
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: @"Root Item Not Loaded"
                                                       message: error.localizedDescription
                                                      delegate: nil
                                             cancelButtonTitle: @"Okay"
                                             otherButtonTitles: nil ];
    
    [ alert show ];
}

-(void)didLoadRootItem:( SCItem* )rootItem
{
    self.itemsBrowserController.rootItem = rootItem;
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
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: @"Cannot navigate to Root"
                                                       message: @"Root item unavailable"
                                                      delegate: nil
                                             cancelButtonTitle: @"Ok. I understand."
                                             otherButtonTitles: nil ];
    [ alert show ];
}

-(void)showCannotReloadMessage
{
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: @"Cannot reload the level"
                                                       message: @"Root item unavailable"
                                                      delegate: nil
                                             cancelButtonTitle: @"Ok. I understand."
                                             otherButtonTitles: nil ];
    [ alert show ];
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
    UIAlertView* alert = [ [ UIAlertView alloc ] initWithTitle: @"Level Not Loaded"
                                                       message: error.localizedDescription
                                                      delegate: nil
                                             cancelButtonTitle: @"Okay"
                                             otherButtonTitles: nil ];
    
    [ alert show ];
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
    return Nil;
}

-(Class)cellClassForItem:( SCItem* )item
{
    return Nil;
}

-(UICollectionViewCell*)itemsBrowser:( SCItemGridBrowser* )sender
        createLevelUpCellAtIndexPath:( NSIndexPath* )indexPath
{
    NSString* reuseId = [ self levelUpCellReuseId ];
    Class levelUpCellClass = [ self levelUpCellClass ];
    
    UICollectionView* collectionView = self->_itemsBrowserController.collectionView;
    [ collectionView registerClass: levelUpCellClass
        forCellWithReuseIdentifier: reuseId ];
    
    UICollectionViewCell* result =
    [ collectionView dequeueReusableCellWithReuseIdentifier: reuseId
                                               forIndexPath: indexPath ];
    
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
    
    return result;
}

@end
