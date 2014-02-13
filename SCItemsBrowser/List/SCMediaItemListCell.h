#import <SCItemsBrowser/List/SCItemListCell.h>

@class SCExtendedApiContext;

@interface SCMediaItemListCell : SCItemListCell

-(id)initWithStyle:( UITableViewCellStyle  )style
   reuseIdentifier:( NSString            * )reuseIdentifier
        apiContext:( SCExtendedApiContext* )apiContext
       imageParams:( SCFieldImageParams  * )imageResizingOptions;

@end
