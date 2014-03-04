#import <SitecoreItemsBrowser/SCItemCell.h>
#import <Foundation/Foundation.h>

@protocol SCMediaCellEvents;

@class SCItem;
@class SCFieldImageParams;

@interface SCMediaCellController : NSObject<SCItemCell>

@property ( nonatomic, weak  , readwrite ) id<SCMediaCellEvents>  delegate            ;
@property ( nonatomic, strong, readwrite ) SCFieldImageParams   * imageResizingOptions;

@property ( nonatomic, readonly ) SCItem* item;

@end
