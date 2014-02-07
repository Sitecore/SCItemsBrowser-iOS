#import <Foundation/Foundation.h>


@class SCItem;
@class SCItemsReaderRequest;


@interface SCLevelsHistory : NSObject

-(void)pushRequest:( SCItemsReaderRequest* )request
           forItem:( SCItem* )item;

-(SCItemsReaderRequest*)lastRequest;
-(SCItem*)lastItem;

-(void)popRequest;

@end
