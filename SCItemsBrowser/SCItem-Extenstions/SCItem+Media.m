#import "SCItem+Media.h"

static NSString* const mediaRoot = @"/sitecore/media library";

@implementation SCItem (Media)

-(BOOL)isMediaItem
{
    BOOL result = ( [ self.path hasPrefix: mediaRoot ] );
    
    return result;
}

-(NSString*)mediaPath
{
    if ( ! [ self isMediaItem ] )
    {
        return nil;
    }
    
    NSString* mediaPath = [ self.path substringFromIndex: [ mediaRoot length ] ];
    return mediaPath;
}

@end
