#import <Foundation/Foundation.h>


@protocol SCItemsBrowserDelegate <NSObject>

-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id )progressInfo;

-(void)itemsBrowser:( id )sender
levelLoadingFailedWithError:( NSError* )error;

-(void)itemsBrowser:( id )sender
didLoadLevelForItem:( SCItem* )levelParentItem;

@end
