#import "LBViewController.h"

#import <SCItemsBrowser/SCItem-Extenstions/SCItem+Media.h>

#define CUSTOMIZATION_ENABLED 1

//static NSString* const ROOT_ITEM_PATH = @"/sitecore/content/home";
static NSString* const ROOT_ITEM_PATH = @"/sitecore/Media Library";

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
}

#pragma mark -
#pragma mark SIBListModeCellFactory
static NSString* const LEVEL_UP_CELL_ID = @"net.sitecore.MobileSdk.ItemsBrowser.list.LevelUpCell";
static NSString* const ITEM_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell"   ;
static NSString* const IMAGE_CELL_ID     = @"net.sitecore.MobileSdk.ItemsBrowser.list.ItemCell.image";


-(NSString*)levelUpCellReuseIdentifier
{
    return LEVEL_UP_CELL_ID;
}

-(BOOL)isImageItem:( SCItem* )item
{
    BOOL isUnversionedImage = [ item.itemTemplate isEqualToString: @"System/Media/Unversioned/Image" ];
    BOOL isJpegImage        = [ item.itemTemplate isEqualToString: @"System/Media/Unversioned/Jpeg"  ];
    
    return isUnversionedImage || isJpegImage;
}

-(NSString*)itemCellReuseIdentifierForItem:( SCItem* )item
{
//    NSLog( @"%@", item.itemTemplate );
    
    if ( [ self isImageItem: item ] )
    {
        return IMAGE_CELL_ID;
    }
    else
    {
        return ITEM_CELL_ID;
    }
}

-(UITableViewCell*)createLevelUpCellForListMode
{
    UITableViewCell* cell = [ [ UITableViewCell alloc ] initWithStyle: UITableViewCellStyleDefault
                                                      reuseIdentifier: LEVEL_UP_CELL_ID ];
    cell.textLabel.text = @"..";
    
    return cell;
}

-(UITableViewCell<SCItemCell>*)createListModeCellForItem:( SCItem* )item
{
//    NSLog( @"%@", item.itemTemplate );
    
    SCItemListCell* cell = nil;
    NSString* cellId = [ self itemCellReuseIdentifierForItem: item ];
    
    if ( [ item isMediaItem ] )
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
-(NSString*)levelHeaderTitleForTableViewSection
{
    return @"Level Header";
}

-(NSString*)levelFooterTitleForTableViewSection
{
    return @"Level Footer";
}
#endif
@end
