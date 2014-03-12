#import "SCMediaItemListCell.h"

#import "SCMediaCellEvents.h"
#import "SCMediaCellController.h"


@interface SCMediaItemListCell()<SCMediaCellEvents>
@end

@implementation SCMediaItemListCell
{
    UIActivityIndicatorView* _progress;
    SCMediaCellController* _imageLoader;
}


-(id)initWithStyle:( UITableViewCellStyle )style
   reuseIdentifier:( NSString* )reuseIdentifier
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithStyle:( UITableViewCellStyle  )style
   reuseIdentifier:( NSString            * )reuseIdentifier
       imageParams:( SCDownloadMediaOptions  * )imageResizingOptions
{
    self = [ super initWithStyle: style
                 reuseIdentifier: reuseIdentifier ];
    if ( nil == self )
    {
        return nil;
    }

    self->_progress = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];

    self->_imageLoader = [ SCMediaCellController new ];
    self->_imageLoader.delegate = self;
    self->_imageLoader.imageResizingOptions = imageResizingOptions;


    return self;
}

-(NSString*)getMediaPathForItem:( SCItem* )item
{
    return [ item mediaPath ];
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

#pragma mark -
#pragma mark SCMediaCellEvents
-(void)didStartLoadingImageInMediaCellController:( SCMediaCellController* )sender
{
    self.imageView.image = nil;
    self.textLabel.text = self->_imageLoader.item.displayName;

    
    [ self startLoading   ];
    [ self setNeedsLayout ];
}

-(void)mediaCellController:( SCMediaCellController* )sender
     didFinishLoadingImage:( UIImage* )image
                   forItem:( SCItem* )mediaItem;
{
    [ self stopLoading ];
    
    self.imageView.image = image;
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
