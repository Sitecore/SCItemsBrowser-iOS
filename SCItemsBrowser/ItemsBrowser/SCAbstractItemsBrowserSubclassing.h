#import <Foundation/Foundation.h>

@class NSIndexPath;

@protocol SCAbstractItemsBrowserSubclassing <NSObject>

-(void)didSelectItem:( id )selectedItem
         atIndexPath:( NSIndexPath* )indexPath;

-(void)reloadContentView;


@end
