#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface SCItem (Media)

-(BOOL)isMediaItem;
-(BOOL)isMediaImage;
-(BOOL)isFolder;

-(NSString*)mediaPath;
-(SCExtendedAsyncOp)mediaLoaderWithOptions:( SCFieldImageParams* )options;

@end
