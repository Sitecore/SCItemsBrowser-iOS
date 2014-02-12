#import "LBViewController.h"

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
    [ SCApiContext contextWithHost: @"http://mobiledev1ua1.dk.sitecore.net:722"
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
    [ self->_apiContext itemReaderForItemPath: @"/sitecore/content/home"
                                   itemSource: nil ];
    
    [ self startLoading ];
    __weak LBViewController* weakSelf = self;
    rootItemLoader( nil, nil, ^( SCItem* rootItem, NSError* blockError )
    {
        [ weakSelf endLoading ];
        
       if ( nil != rootItem )
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
    [ self.loadingProgress startAnimating ];
}

-(void)endLoading
{
    [ self.loadingProgress stopAnimating ];
}


#pragma mark -
#pragma mark SCItemsBrowserDelegate
-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id<SCUploadProgress> )progressInfo
{
    NSLog( @"%@ loaded. %@", [ progressInfo progress ], [ progressInfo url ] );
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
    self.itemPathTextView.text = levelParentItem.displayName;
}

#pragma mark -
#pragma mark SIBListModeCellFactory
static NSString* const LEVEL_UP_CELL_ID = @"net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell";
static NSString* const ITEM_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"   ;



-(NSString*)levelUpCellReuseIdentifier
{
    return LEVEL_UP_CELL_ID;
}

-(NSString*)itemCellReuseIdentifier
{
    return ITEM_CELL_ID;
}

-(UITableViewCell*)createLevelUpCellForListMode
{
    UITableViewCell* cell = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                                      reuseIdentifier: LEVEL_UP_CELL_ID ];
    cell.textLabel.text = @"..";
    
    return cell;
}

-(UITableViewCell<SCItemCell>*)createCellForListMode
{
    SCItemListTextCell* cell =
    [ [ SCItemListTextCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                 reuseIdentifier: ITEM_CELL_ID ];

    return cell;
}

@end
