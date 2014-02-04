#import <Foundation/Foundation.h>

@class SCItem;

@protocol SCItemCell <NSObject>

-(void)setModel:( SCItem* )item;
-(void)reloadData;

@end
