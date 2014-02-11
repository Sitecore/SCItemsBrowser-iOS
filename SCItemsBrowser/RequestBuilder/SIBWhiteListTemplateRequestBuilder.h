#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsLevelRequestBuilder.h>

@interface SIBWhiteListTemplateRequestBuilder : NSObject< SCItemsLevelRequestBuilder >

-(instancetype)initWithTemplateNames:( NSArray* )templateNames;

@end
