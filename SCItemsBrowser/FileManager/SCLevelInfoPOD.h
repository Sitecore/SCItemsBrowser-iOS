#import <Foundation/Foundation.h>


@class SCItem;
@class SCItemsReaderRequest;


@interface SCLevelInfoPOD : NSObject

-(instancetype)initWithLevelRequest:( SCItemsReaderRequest* )levelRequest
                            forItem:( SCItem* )item;

@property ( nonatomic, readonly ) SCItemsReaderRequest* levelRequest;
@property ( nonatomic, readonly ) SCItem* levelParentItem;

@end
