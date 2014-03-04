#import <Foundation/Foundation.h>

@class SCItem;

@interface SCLevelResponse : NSObject

-(instancetype)initWithItem:( SCItem* )levelParentItem
          levelContentItems:( NSArray* )levelContentItems;

@property ( nonatomic, readonly ) SCItem*  levelParentItem  ;
@property ( nonatomic, readonly ) NSArray* levelContentItems;

@end
