#import <Foundation/Foundation.h>

@class UITableViewCell;
@protocol SCItemCell;

@protocol SIBListModeCellFactory <NSObject>

-(UITableViewCell*)createLevelUpCellForListMode;
-(UITableViewCell<SCItemCell>*)createCellForListMode;

@end
