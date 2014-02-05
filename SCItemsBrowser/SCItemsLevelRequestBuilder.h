#import <Foundation/Foundation.h>

@class SCItem;
@class SCItemsReaderRequest;

@protocol SCItemsLevelRequestBuilder <NSObject>

-(SCItemsReaderRequest*)levelDownRequestForItem:( SCItem* )item;

@end
