#import <Foundation/Foundation.h>

@class SCItem;
@class SCItemsReaderRequest;

@protocol SCItemsLevelRequestBuilder <NSObject>

-(SCItemsReaderRequest*)itemsBrowser:( id )sender
             levelDownRequestForItem:( SCItem* )item;

@end
