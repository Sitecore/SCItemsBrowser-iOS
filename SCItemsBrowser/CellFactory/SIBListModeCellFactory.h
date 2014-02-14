#import <Foundation/Foundation.h>

@class SCItem;
@class UITableViewCell;

@protocol SCItemCell;

@protocol SIBListModeCellFactory <NSObject>

-(UITableViewCell*)createLevelUpCellForListModeOfItemsBrowser:( id )sender;
-(UITableViewCell<SCItemCell>*)itemsBrowser:( id )sender
                  createListModeCellForItem:( SCItem* )item;

-(NSString*)reuseIdentifierForLevelUpCellOfItemsBrowser:( id )sender;
-(NSString*)itemsBrowser:( id )sender
itemCellReuseIdentifierForItem:( SCItem* )item;

@end
