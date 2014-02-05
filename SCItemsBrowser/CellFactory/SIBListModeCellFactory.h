#import <Foundation/Foundation.h>

@class UITableViewCell;
@protocol SCItemCell;

@protocol SIBListModeCellFactory <NSObject>

-(UITableViewCell<SCItemCell>*)createCellForListMode;

@end
