#import <Foundation/Foundation.h>

@protocol SCUploadProgress;

@protocol SCItemsBrowserDelegate <NSObject>

-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id<SCUploadProgress> )progressInfo;

-(void)itemsBrowser:( id )sender
levelLoadingFailedWithError:( NSError* )error;

-(void)itemsBrowser:( id )sender
didLoadLevelForItem:( SCItem* )levelParentItem;

@end
