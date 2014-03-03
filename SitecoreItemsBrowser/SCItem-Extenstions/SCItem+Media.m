#import "SCItem+Media.h"

static NSString* const MEDIA_ROOT = @"/SITECORE/MEDIA LIBRARY";


@implementation SCItem (Media)

-(NSLocale*)posixLocale
{
    static NSLocale* posixLocale = nil;

    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^void()
    {
        posixLocale = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
    } );

    return posixLocale;
}

-(BOOL)isFolder
{
    NSString* itemTemplate = [ self.itemTemplate uppercaseStringWithLocale: [ self posixLocale ] ];
    
    NSArray* folderTemplates =
    @[
      @"SYSTEM/MEDIA/MEDIA FOLDER",
      @"COMMON/FOLDER"
    ];
    
    NSSet* folderTemplateSet = [ NSSet setWithArray: folderTemplates ];
    return [ folderTemplateSet containsObject: itemTemplate ];
}

-(BOOL)isImage
{
    NSString* itemTemplate = [ self.itemTemplate uppercaseStringWithLocale: [ self posixLocale ] ];
    NSArray* imageTemplates =
    @[
       @"SYSTEM/MEDIA/UNVERSIONED/IMAGE",
       @"SYSTEM/MEDIA/UNVERSIONED/JPEG" ,
       @"SYSTEM/MEDIA/VERSIONED/JPEG"
    ];
    NSSet* imageTemplatesSet = [ NSSet setWithArray: imageTemplates ];
    
    return [ imageTemplatesSet containsObject: itemTemplate ];
}

-(BOOL)isMediaImage
{
    BOOL result =
        [ self isMediaItem ] &&
        [ self isImage ];

    return result;
}

-(BOOL)isMediaItem
{
    NSString* path = [ self.path uppercaseStringWithLocale: [ self posixLocale ] ];
    
    
    BOOL result = ( [ path hasPrefix: MEDIA_ROOT ] );
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

-(SCExtendedAsyncOp)mediaLoaderWithOptions:( SCDownloadMediaOptions* )options
{
    if ( [ self isMediaItem ] )
    {
        if ( nil == options )
        {
            options = [ SCDownloadMediaOptions new ];
        }
        
        SCItemSourcePOD* recordSource = [ self recordItemSource ];
        {
            options.database = recordSource.database;
            options.language = recordSource.language;
            options.version  = recordSource.itemVersion;
        }
        
        
        NSString* mediaPath = [ self mediaPath ];
        
        return [ self.apiSession imageLoaderForSCMediaPath: mediaPath
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
    SCItemSourcePOD* recordSource = [ record performSelector: @selector(getSource) ];
    
    return recordSource;
#pragma clang diagnostic pop
}

@end
