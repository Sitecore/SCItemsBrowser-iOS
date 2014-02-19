#import <Foundation/Foundation.h>
#import <SCItemsBrowser/SCItemsLevelRequestBuilder.h>


/**
 An abstract class for template based item filters. It is used for subclassing only.
 Do not use it explicitly.
 
 Instead, one of the classes below should be used :
 * SIBWhiteListTemplateRequestBuilder
 * SIBBlackListTemplateRequestBuilder
 
 */
@interface SIBAbstractTemplateListRequestBuilder : NSObject<SCItemsLevelRequestBuilder>

/**
 Unsupported initializer. It throws an exception when called.
 Use initWithTemplateNames: instead.
 */
-(instancetype)init;

/**
 Designated initializer.
 
 @param templateNames Names of templates for filtering. Do not include full path entries.
 For example, 
 [ [ SIBAbstractTemplateListRequestBuilder alloc ] initWithTemplateNames: @[ @"Folder", @"Item", @"Image" ] ];
 
 @return A properly initialized filter.
 */
-(instancetype)initWithTemplateNames:( NSArray* )templateNames;

/**
 Template names passed to the designated initializer.
 */
@property ( nonatomic, readonly ) NSArray* templateNames;

@end
