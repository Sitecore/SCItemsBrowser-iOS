#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface SCItem (Media)

-(BOOL)isMediaItem;
-(BOOL)isMediaImage;

-(NSString*)mediaPath;
-(SCExtendedAsyncOp)mediaLoaderWithOptions:( SCFieldImageParams* )options;

@end
