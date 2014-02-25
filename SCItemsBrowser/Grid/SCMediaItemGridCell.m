#import "SCMediaItemGridCell.h"

#import "SCItem+Media.h"

@implementation SCMediaItemGridCell
{
    UIImageView            * _imageView        ;
    UIActivityIndicatorView* _progress         ;
    SCItem                 * _item             ;
    SCCancelAsyncOperation   _cancelImageLoader;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame: frame ];
    if ( nil == self )
    {
        return nil;
    }
    
    [ self setupUI ];
    
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

-(void)setModel:( SCItem* )item
{
    self->_item = item;
}

-(void)reloadData
{
    __weak SCMediaItemGridCell* weakSelf = self;

    UIImageView* imageView = self->_imageView;
    self->_imageView.image = nil;
    
//    self.textLabel.text = self->_item.displayName;
    if ( ![ self->_item isMediaImage ] )
    {
        return;
    }
    
    
    SCExtendedAsyncOp imageLoader = [ self->_item mediaLoaderWithOptions: self->_imageResizingOptions ];
    SCDidFinishAsyncOperationHandler onImageLoadedBlock = ^void( UIImage* loadedImage, NSError* imageError )
    {
        [ weakSelf stopLoading ];
        
        imageView.image = loadedImage;
        [ weakSelf setNeedsLayout ];
        
        if ( nil == loadedImage )
        {
            NSLog( @"[INFO] : image loading failed for item : |%@|", self->_item );
        }
    };
    
    
    imageView.image = nil;
    [ self startLoading   ];
    [ self setNeedsLayout ];
    self->_cancelImageLoader = imageLoader( nil, nil, onImageLoadedBlock );
    self->_cancelImageLoader = [ self->_cancelImageLoader copy ];
}

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

@end
