#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsLevelRequestBuilder.h>


@interface SIBBlackListTemplateRequestBuilder : NSObject< SCItemsLevelRequestBuilder >

-(instancetype)initWithTemplateNames:( NSArray* )templateNames;

@end
