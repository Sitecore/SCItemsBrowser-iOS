#import <Foundation/Foundation.h>


@protocol SCItemsBrowserDelegate <NSObject>

-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id )progressInfo;

-(void)itemsBrowser:( id )sender
levelLoadingFailedWithError:( NSError* )error;

-(BOOL)itemsBrowser:( id )sender
shouldLoadLevelForItem:( SCItem* )levelParentItem;

-(void)itemsBrowser:( id )sender
didLoadLevelForItem:( SCItem* )levelParentItem;

@end
