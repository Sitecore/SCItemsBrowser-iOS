#import "SCItem+Media.h"

static NSString* const MEDIA_ROOT = @"/sitecore/media library";


@implementation SCItem (Media)


-(BOOL)isFolder
{
    NSString* itemTemplate = self.itemTemplate;
    
    BOOL isMediaFolder = [ itemTemplate isEqualToString: @"System/Media/Media folder" ];
    BOOL isCommonFolder = [ itemTemplate isEqualToString: @"Common/Folder" ];
    
    return isMediaFolder || isCommonFolder;
}

-(BOOL)isMediaImage
{
    if ( ![ self isMediaItem ] )
    {
        return NO;
    }
    
    NSString* itemTemplate = self.itemTemplate;
    
    BOOL isUnversionedImage = [ itemTemplate isEqualToString: @"System/Media/Unversioned/Image" ];
    BOOL isJpegImage        = [ itemTemplate isEqualToString: @"System/Media/Unversioned/Jpeg"  ];
    
    return isUnversionedImage || isJpegImage;
}

-(BOOL)isMediaItem
{
    BOOL result = ( [ self.path hasPrefix: MEDIA_ROOT ] );
    return result;
}

-(NSString*)mediaPath
{
    if ( ! [ self isMediaItem ] )
    {
        return nil;
    }
    
    NSString* mediaPath = [ self.path substringFromIndex: [ MEDIA_ROOT length ] ];
    return mediaPath;
}

-(SCExtendedAsyncOp)mediaLoaderWithOptions:( SCFieldImageParams* )options
{
    if ( [ self isMediaItem ] )
    {
        if ( nil == options )
        {
            options = [ SCFieldImageParams new ];
        }
        
        SCItemSourcePOD* recordSource = [ self recordItemSource ];
        {
            options.database = recordSource.database;
            options.language = recordSource.language;
            options.version  = recordSource.itemVersion;
        }
        
        
        NSString* mediaPath = [ self mediaPath ];
        
        return [ self.apiContext imageLoaderForSCMediaPath: mediaPath
                                               imageParams: options ];
        
    }
    else
    {
        return nil;
    }
}

-(SCItemSourcePOD*)recordItemSource
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id record = [ self performSelector: @selector( record ) ];
    SCItemSourcePOD* recordSource = [ record performSelector: @selector(itemSource) ];
    
    return recordSource;
#pragma clang diagnostic pop
}

@end
