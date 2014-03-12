#import "SCMediaItemGridCell.h"



#import "SCMediaCellEvents.h"
#import "SCMediaCellController.h"


@interface SCMediaItemGridCell()<SCMediaCellEvents>
@end

@implementation SCMediaItemGridCell
{
    UIImageView            * _imageView  ;
    UIActivityIndicatorView* _progress   ;
    SCMediaCellController  * _imageLoader;
}

@dynamic imageResizingOptions;

-(instancetype)initWithFrame:( CGRect )frame
{
    self = [ super initWithFrame: frame ];
    if ( nil == self )
    {
        return nil;
    }
    
    [ self setupUI ];
    self->_imageLoader = [ SCMediaCellController new ];
    self->_imageLoader.delegate = self;
    
    return self;
}

-(void)setupUI
{
    CGRect imageFrame = self.contentView.frame;
    imageFrame.origin = CGPointMake( 0, 0 );
    
    UIImageView* imageView = [ [ UIImageView alloc ] initWithFrame: imageFrame ];
    self->_imageView = imageView;
    
    UIActivityIndicatorView* progress =
    [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
    self->_progress = progress;
    self->_progress.center = CGPointMake( imageFrame.size.width / 2. , imageFrame.size.height / 2. );
    
    [ self.contentView addSubview: imageView ];
    [ self.contentView addSubview: progress  ];
}

-(SCDownloadMediaOptions*)imageResizingOptions
{
    NSParameterAssert( nil != self->_imageLoader );
    return self->_imageLoader.imageResizingOptions;
}

-(void)setImageResizingOptions:(SCDownloadMediaOptions *)imageResizingOptions
{
    NSParameterAssert( nil != self->_imageLoader );
    self->_imageLoader.imageResizingOptions = imageResizingOptions;
}

-(void)setModel:( SCItem* )item
{
    NSParameterAssert( nil != self->_imageLoader );

    [ self->_imageLoader setModel: item ];
}

-(void)reloadData
{
    NSParameterAssert( nil != self->_imageLoader );
    
    [ self->_imageLoader reloadData ];
}

#pragma mark - 
#pragma mark Progress view
-(void)startLoading
{
    [ self addSubview: self->_progress ];
    [ self->_progress startAnimating ];
}

-(void)stopLoading
{
    [ self->_progress stopAnimating       ];
    [ self->_progress removeFromSuperview ];
}

-(void)layoutSubviews
{
    [ super layoutSubviews ];
    self->_progress.center = CGPointMake( self.frame.size.width / 2., self.frame.size.height / 2. );
    
    CGRect imageFrame = self.contentView.frame;
    imageFrame.origin = CGPointMake( 0, 0 );
    self->_imageView.frame = imageFrame;
}

#pragma mark -
#pragma mark SCMediaCellEvents
-(void)didStartLoadingImageInMediaCellController:( SCMediaCellController* )sender
{
    self->_imageView.image = nil;

    [ self startLoading   ];
    [ self setNeedsLayout ];
}

-(void)mediaCellController:( SCMediaCellController* )sender
     didFinishLoadingImage:( UIImage* )image
                   forItem:( SCItem* )mediaItem;
{
    [ self stopLoading ];
    
    self->_imageView.image = image;
    [ self setNeedsLayout ];
}

-(void)mediaCellController:( SCMediaCellController* )sender
didFailLoadingImageForItem:( SCItem* )mediaItem
                 withError:( NSError* )error
{
    [ self stopLoading ];
    NSLog( @"[INFO] : image loading failed for item : |%@|. Error : |%@|", mediaItem, error );
}

@end
