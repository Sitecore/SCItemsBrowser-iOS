#import <Foundation/Foundation.h>


@class SCItem;
@class SCItemsReaderRequest;


@interface SCLevelsHistory : NSObject

-(void)pushRequest:( SCItemsReaderRequest* )request
           forItem:( SCItem* )item;

-(void)popRequest;

-(BOOL)isLevelUpAvailable;

// starts from "1"
-(NSUInteger)currentLevel;

-(SCItemsReaderRequest*)lastRequest;
-(SCItem*)lastItem;

-(SCItemsReaderRequest*)levelUpRequest;
-(SCItem*)levelUpParentItem;



@end
