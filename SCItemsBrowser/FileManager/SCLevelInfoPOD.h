#import <Foundation/Foundation.h>


@class SCItem;
@class SCReadItemsRequest;


@interface SCLevelInfoPOD : NSObject

-(instancetype)initWithLevelRequest:( SCReadItemsRequest* )levelRequest
                            forItem:( SCItem* )item;

@property ( nonatomic, readonly ) SCReadItemsRequest* levelRequest;
@property ( nonatomic, readonly ) SCItem* levelParentItem;

@end
