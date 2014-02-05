#import <Foundation/Foundation.h>

@class SCExtendedApiContext;
@protocol SCItemsLevelRequestBuilder;


@interface SCItemsFileManager : NSObject

-(instancetype)initWithApiContext:( SCExtendedApiContext* )apiContext
              levelRequestBuilder:( id<SCItemsLevelRequestBuilder> )nextLevelRequestBuilder;

//-(void)loadLevelForItem:( SCItem* )item
//             completion:;

@end
