#import "LBViewController.h"

@interface LBViewController ()
<
    SCItemsBrowserDelegate,
    SIBListModeAppearance ,
    SIBListModeCellFactory,
    SCItemsLevelRequestBuilder
>

@property (strong, nonatomic) IBOutlet SCItemListBrowser *itemsBrowserController;
@property (weak, nonatomic) IBOutlet UITextView *itemPathTextView;

@end

@implementation LBViewController
{
    SCApiContext* _legacyApiContext;
    SCExtendedApiContext* _apiContext;
}

-(void)setupContext
{
    self->_legacyApiContext = [ SCApiContext contextWithHost: @"http://mobiledev1ua1.dk.sitecore.net:722"
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
        
    [ self->_apiContext itemReaderForItemPath: @"/sitecore/content/home"
                                   itemSource: nil ];
}

-(void)didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark SCItemsBrowserDelegate
-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id<SCUploadProgress> )progressInfo
{
    NSAssert( NO, @"not implemented" );
}

-(void)itemsBrowser:( id )sender
levelLoadinFailedWithError:( NSError* )error
{
    NSAssert( NO, @"not implemented" );    
}

#pragma mark -
#pragma mark SIBListModeCellFactory
-(UITableViewCell*)createLevelUpCellForListMode
{
    NSAssert( NO, @"not implemented" );
    return nil;
}

-(UITableViewCell<SCItemCell>*)createCellForListMode
{
    NSAssert( NO, @"not implemented" );
    return nil;
}


#pragma mark -
#pragma mark SCItemsLevelRequestBuilder
-(SCItemsReaderRequest*)levelDownRequestForItem:( SCItem* )item
{
    NSAssert( NO, @"not implemented" );
    return nil;
}

@end
