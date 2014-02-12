#import <Foundation/Foundation.h>

@class SCItem;
@class UITableViewCell;

@protocol SCItemCell;

@protocol SIBListModeCellFactory <NSObject>

-(UITableViewCell*)createLevelUpCellForListMode;
-(UITableViewCell<SCItemCell>*)createListModeCellForItem:( SCItem* )item;

-(NSString*)levelUpCellReuseIdentifier;
-(NSString*)itemCellReuseIdentifier;

@end
