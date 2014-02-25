#import "SCMediaItemListCell.h"

#import "SCItem+Media.h"

@implementation SCMediaItemListCell
{
    SCItem                * _item;
    SCFieldImageParams    * _imageResizingOptions;
    SCCancelAsyncOperation  _cancelImageLoader;
    
    UIActivityIndicatorView* _progress;
}


-(id)initWithStyle:( UITableViewCellStyle )style
   reuseIdentifier:( NSString* )reuseIdentifier
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithStyle:( UITableViewCellStyle  )style
   reuseIdentifier:( NSString            * )reuseIdentifier
       imageParams:( SCFieldImageParams  * )imageResizingOptions
{
    self = [ super initWithStyle: style
                 reuseIdentifier: reuseIdentifier ];
    if ( nil == self )
    {
        return nil;
    }

    self->_imageResizingOptions = imageResizingOptions;
    self->_progress = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];

    return self;
}

-(NSString*)getMediaPathForItem:( SCItem* )item
{
    return [ item mediaPath ];
}

-(void)setModel:( SCItem* )item
{
    if ( nil != self->_cancelImageLoader )
    {
        self->_cancelImageLoader( YES );
    }
    self->_cancelImageLoader = nil;
    self->_item = item;
}

-(void)reloadData
{
    __weak SCMediaItemListCell* weakSelf = self;
    
    self.imageView.image = nil;
    self.textLabel.text = self->_item.displayName;
    if ( ![ self->_item isMediaImage ] )
    {
        return;
    }
    

    SCExtendedAsyncOp imageLoader = [ self->_item mediaLoaderWithOptions: self->_imageResizingOptions ];
    SCDidFinishAsyncOperationHandler onImageLoadedBlock = ^void( UIImage* loadedImage, NSError* imageError )
    {
        [ weakSelf stopLoading ];
        
        weakSelf.imageView.image = loadedImage;
        [ weakSelf setNeedsLayout ];

        
        if ( nil == loadedImage )
        {
            NSLog( @"[INFO] : image loading failed for item : |%@|", self->_item );
        }
    };
    
    
    weakSelf.imageView.image = nil;
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
}

@end
