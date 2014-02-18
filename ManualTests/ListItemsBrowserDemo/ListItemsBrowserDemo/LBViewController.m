#import "LBViewController.h"

#import <SCItemsBrowser/SCItem-Extenstions/SCItem+Media.h>

#define CUSTOMIZATION_ENABLED 0

//static NSString* const ROOT_ITEM_PATH = @"/sitecore/content/home/android/100items";

static NSString* const ROOT_ITEM_PATH = @"/sitecore/content/home";

@interface LBViewController ()
<
    SCItemsBrowserDelegate,
    SIBListModeAppearance ,
    SIBListModeCellFactory
>

@property (strong, nonatomic) IBOutlet SCItemListBrowser *itemsBrowserController;
@property (strong, nonatomic) IBOutlet SIBAllChildrenRequestBuilder *allChildrenRequestBuilder;

@property (weak, nonatomic) IBOutlet UITextView *itemPathTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingProgress;

@end

@implementation LBViewController
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

    self->_legacyApiContext.defaultDatabase = @"web";
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
    __weak LBViewController* weakSelf = self;
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


-(IBAction)onRootButtonTapped:(id)sender
{
    if ( nil == self->_itemsBrowserController.rootItem )
    {
        return;
    }

    [ self->_itemsBrowserController navigateToRootItem ];
}

-(IBAction)onReloadButtonTapped:(id)sender
{
    [ self->_itemsBrowserController forceRefreshData ];
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
    
    
    // should this be inside the component ?
    NSIndexPath* top = [ NSIndexPath indexPathForRow: 0
                                           inSection: 0 ];
    
    UITableView* tableView = self->_itemsBrowserController.tableView;
    [ tableView scrollToRowAtIndexPath: top
                      atScrollPosition: UITableViewScrollPositionTop
                              animated: NO ];
}

#pragma mark -
#pragma mark SIBListModeCellFactory
static NSString* const LEVEL_UP_CELL_ID = @"net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell";
static NSString* const ITEM_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"   ;
static NSString* const IMAGE_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image";


-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:( id )sender
{
    return LEVEL_UP_CELL_ID;
}

-(NSString*)itemsBrowser:( id )sender
itemCellReuseIdentifierForItem:( SCItem* )item
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

-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:( id )sender
{
    UITableViewCell* cell = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                                      reuseIdentifier: LEVEL_UP_CELL_ID ];
    cell.textLabel.text = @"..";
    
    return cell;
}

-(UITableViewCell<SCItemCell>*)itemsBrowser:( id )sender
                  createListModeCellForItem:( SCItem* )item
{
    SCItemListCell* cell = nil;
    NSString* cellId = [ self itemsBrowser: self->_itemsBrowserController
            itemCellReuseIdentifierForItem: item ];
    
    if ( [ item isMediaImage ] )
    {
        cell =
        [ [ SCMediaItemListCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                      reuseIdentifier: cellId
                                          imageParams: nil ];
    }
    else
    {
        cell = [ [ SCItemListTextCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                            reuseIdentifier: cellId ];
    }

    return cell;
}

-(BOOL)itemsBrowser:( id )sender
shouldLoadLevelForItem:( SCItem* )levelParentItem
{
    return levelParentItem.isFolder || levelParentItem.hasChildren;
}

#pragma mark -
#pragma mark Theme

#if CUSTOMIZATION_ENABLED
-(NSString*)levelHeaderTitleForTableViewSectionOfItemsBrowser:( id )sender
{
    return @"Level Header";
}

-(NSString*)levelFooterTitleForTableViewSectionOfItemsBrowser:( id )sender
{
    return @"Level Footer";
}

-(UIView*)levelHeaderViewForTableViewSectionOfItemsBrowser:( id )sender
{
    UIButton* result = [ UIButton buttonWithType: UIButtonTypeInfoDark ];
    [result setTitle: @"Header Custom Button"
            forState: UIControlStateNormal ];

    return result;
}

-(UIView*)levelFooterViewForTableViewSectionOfItemsBrowser:( id )sender
{
    UIButton* result = [ UIButton buttonWithType: UIButtonTypeContactAdd ];
    [result setTitle: @"Footer Custom Button"
            forState: UIControlStateNormal ];
    
    return result;
}

-(CGFloat)levelHeaderHeightForTableViewSectionOfItemsBrowser:( id )sender
{
    return 100;
}

-(CGFloat)levelFooterHeightForTableViewSectionOfItemsBrowser:( id )sender
{
    return 50;
}

-(CGFloat)itemsBrowser:( id )sender
levelUpCellHeigtAtIndexPath:( NSIndexPath* )indexPath
{
    return 44;
}

-(CGFloat)itemsBrowser:( id )sender
   heightOfCellForItem:( SCItem* )item
           atIndexPath:( NSIndexPath* )indexPath
{
    if ( [ item isMediaImage ] )
    {
        return 100;
    }
    else
    {
        return 44;
    }
}

#endif
@end
