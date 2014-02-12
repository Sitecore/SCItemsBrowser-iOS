#import "StubItemsBrowserDelegate.h"

@implementation StubItemsBrowserDelegate

-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id<SCUploadProgress> )progressInfo
{
}

-(void)itemsBrowser:( id )sender
levelLoadinFailedWithError:( NSError* )error
{
}

@end
