#import "SCItemGridBrowser.h"

@class SCItemsFileManager;

@interface SCItemGridBrowser ()

-(SCItemsFileManager*)lazyItemsFileManager;

-(dispatch_once_t)onceItemsFileManagerToken;
-(SCItemsFileManager*)itemsFileManager;

-(SCLevelResponse*)loadedLevel;
-(void)setLoadedLevel:( SCLevelResponse* )loadedLevel;

-(void)disposeLazyItemsFileManager;

@end
