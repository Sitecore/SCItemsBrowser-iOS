#import <Foundation/Foundation.h>

@protocol SCItemsBrowserProtocol <NSObject>

-(void)reloadData;
-(void)forceRefreshData;
-(void)navigateToRootItem;

@end
