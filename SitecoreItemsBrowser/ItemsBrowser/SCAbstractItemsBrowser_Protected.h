#import "SCAbstractItemsBrowser.h"


@class SCLevelResponse;
@class SCItemsFileManager;


@interface SCAbstractItemsBrowser ()

-(SCItemsFileManager*)lazyItemsFileManager;
-(void)disposeLazyItemsFileManager;

-(SCLevelResponse*)loadedLevel;

-(void)didSelectItem:( id )selectedItem
         atIndexPath:( NSIndexPath* )indexPath;

-(void)reloadDataIgnoringCache:( BOOL )shouldIgnoreCache;

@end
