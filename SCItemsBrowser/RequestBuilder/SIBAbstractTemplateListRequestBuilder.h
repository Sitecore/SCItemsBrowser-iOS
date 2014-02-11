#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsLevelRequestBuilder.h>


@interface SIBAbstractTemplateListRequestBuilder : NSObject<SCItemsLevelRequestBuilder>

-(instancetype)initWithTemplateNames:( NSArray* )templateNames;

@property ( nonatomic, readonly ) NSArray* templateNames;

@end
