#import <Foundation/Foundation.h>

@protocol SCUploadProgress;

@protocol SCItemsBrowserDelegate <NSObject>

-(void)itemsBrowser:( id )sender
didReceiveLevelProgressNotification:( id<SCUploadProgress> )progressInfo;

-(void)itemsBrowser:( id )sender
levelLoadinFailedWithError:( NSError* )error;

@end
