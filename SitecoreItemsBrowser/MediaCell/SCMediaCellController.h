#import <SitecoreItemsBrowser/SCItemCell.h>
#import <Foundation/Foundation.h>

@protocol SCMediaCellEvents;

@class SCItem;
@class SCDownloadMediaOptions;

@interface SCMediaCellController : NSObject<SCItemCell>

@property ( nonatomic, weak  , readwrite ) id<SCMediaCellEvents>  delegate            ;
@property ( nonatomic, strong, readwrite ) SCDownloadMediaOptions   * imageResizingOptions;

@property ( nonatomic, readonly ) SCItem* item;

@end
