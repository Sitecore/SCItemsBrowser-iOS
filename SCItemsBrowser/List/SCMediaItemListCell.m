#import "SCMediaItemListCell.h"

#import "SCItem+Media.h"

@implementation SCMediaItemListCell
{
    SCExtendedApiContext* _apiContext          ;
    SCFieldImageParams  * _imageResizingOptions;
    
    SCCancelAsyncOperation _cancelImageLoader;

    NSString* _displayName;
    NSString* _mediaPath;
}


-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithStyle:( UITableViewCellStyle  )style
   reuseIdentifier:( NSString            * )reuseIdentifier
        apiContext:( SCExtendedApiContext* )apiContext
       imageParams:( SCFieldImageParams  * )imageResizingOptions
{
    self = [ super initWithStyle: style
                 reuseIdentifier: reuseIdentifier ];
    if ( nil == self )
    {
        return nil;
    }

    self->_apiContext           = apiContext          ;
    self->_imageResizingOptions = imageResizingOptions;

    return self;
}

-(NSString*)getMediaPathForItem:( SCItem* )item
{
    return [ item mediaPath ];
}

-(void)setModel:( SCItem* )item
{
    NSString* mediaPath = [ self getMediaPathForItem: item ];
    self->_mediaPath   = mediaPath       ;
    self->_displayName = item.displayName;
}

-(void)reloadData
{
    __weak SCMediaItemListCell* weakSelf = self;
    
    self.textLabel.text = self->_displayName;

    if ( nil == self->_mediaPath )
    {
        return;
    }

    if ( nil != self->_cancelImageLoader )
    {
        self->_cancelImageLoader( YES );
    }
    
    SCExtendedAsyncOp imageLoader =
    [ self->_apiContext imageLoaderForSCMediaPath: self->_mediaPath
                                      imageParams: self->_imageResizingOptions ];
    
    SCDidFinishAsyncOperationHandler onImageLoadedBlock = ^void( UIImage* loadedImage, NSError* imageError )
    {
        if ( nil == loadedImage )
        {
            NSLog( @"[INFO] : image loading failed for item : |%@|", self->_displayName );
        }
        else
        {
            weakSelf.imageView.image = loadedImage;
        }
    };
    
    self->_cancelImageLoader = imageLoader( nil, nil, onImageLoadedBlock );
    self->_cancelImageLoader = [ self->_cancelImageLoader copy ];
}

@end
