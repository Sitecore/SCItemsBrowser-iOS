#import <Foundation/Foundation.h>

@class UICollectionViewCell;
@protocol SCItemCell;

@protocol SIBGridModeCellFactory <NSObject>

-(UICollectionViewCell<SCItemCell>*)createCellForGridMode;

@end

