
static const NSTimeInterval SINGLE_REQUEST_TIMEOUT = 60;

@interface MediaItemOperationTest : GHAsyncTestCase
@end

@implementation MediaItemOperationTest
{
    SCExtendedApiContext* _context;
    SCApiContext* _legacyContext;
}

-(void)setUp
{
    [ super setUp ];

    self->_legacyContext = [ SCApiContext contextWithHost: @"http://mobiledev1ua1.dk.sitecore.net:722"
                                                    login: @"sitecore\\admin"
                                                 password: @"b" ];
    {
        self->_legacyContext.defaultDatabase = @"master";
        self->_legacyContext.defaultSite     = @"/sitecore/shell";
    }
}

-(void)tearDown
{
    self->_context = nil;
    self->_legacyContext = nil;
    
    [ super tearDown ];
}

-(void)testImageIsLoadedCorrectlyForMediaItem
{
    SEL thisTest = _cmd;
    
    __block SCItem * mediaItem   = nil;
    __block UIImage* actualImage = nil;
    __block NSError* actualError = nil;
    
    SCAsyncOp itemLoader = [ self->_legacyContext itemReaderForItemPath: @"/sitecore/Media Library/Images/test image" ];
    
    [ self prepare: thisTest ];
    {
        dispatch_async( dispatch_get_main_queue(), ^void()
        {
            itemLoader( ^void( SCItem* blockMediaItem, NSError* blockError )
            {
                mediaItem   = blockMediaItem;
                actualError = blockError    ;
                
                [ self notify: kGHUnitWaitStatusSuccess
                  forSelector: thisTest ];
            } );
        } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    GHAssertNotNil( mediaItem, @"item load failed"   );
    GHAssertNil   ( actualError, @"unexpected error" );
    

    SCExtendedAsyncOp imageLoader = [ mediaItem mediaLoaderWithOptions: nil ];
    [ self prepare: thisTest ];
    {
        dispatch_async( dispatch_get_main_queue(), ^void()
        {
           imageLoader( nil, nil, ^void( UIImage* blockImage, NSError* blockError )
           {
              actualImage = blockImage;
              actualError = blockError;
               
               [ self notify: kGHUnitWaitStatusSuccess
                 forSelector: thisTest ];
           } );
        } );
    }
    [ self waitForStatus: kGHUnitWaitStatusSuccess
                 timeout: SINGLE_REQUEST_TIMEOUT ];
    
    GHAssertNotNil( actualImage, @"image load failed"   );
    GHAssertNil   ( actualError, @"unexpected error" );
}

@end
