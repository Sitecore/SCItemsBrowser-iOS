#import <SCItemsBrowser/List/SCItemListCell.h>

@class SCFieldImageParams;

@interface SCMediaItemListCell : SCItemListCell

-(id)initWithStyle:( UITableViewCellStyle  )style
   reuseIdentifier:( NSString            * )reuseIdentifier
       imageParams:( SCFieldImageParams  * )imageResizingOptions;

@end
