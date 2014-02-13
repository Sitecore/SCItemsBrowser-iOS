#import "StubItemsBrowserDelegate.h"

@implementation StubItemsBrowserDelegate

-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id )progressInfo
{
}

-(void)itemsBrowser:( id )sender
levelLoadingFailedWithError:( NSError* )error
{
}

-(void)itemsBrowser:( id )sender
didLoadLevelForItem:( SCItem* )levelParentItem
{
}

-(BOOL)itemsBrowser:( id )sender
shouldLoadLevelForItem:( SCItem* )levelParentItem
{
    return YES;
}

@end
