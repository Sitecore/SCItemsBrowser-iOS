#import <Foundation/Foundation.h>


@class SCItem;
@class SCReadItemsRequest;


@interface SCLevelsHistory : NSObject

-(void)pushRequest:( SCReadItemsRequest* )request
           forItem:( SCItem* )item;

-(void)popRequest;

-(BOOL)isLevelUpAvailable;
-(BOOL)isRootLevelLoaded;

// starts from "1"
-(NSUInteger)currentLevel;

-(SCReadItemsRequest*)lastRequest;
-(SCItem*)lastItem;

-(SCReadItemsRequest*)levelUpRequest;
-(SCItem*)levelUpParentItem;



@end
