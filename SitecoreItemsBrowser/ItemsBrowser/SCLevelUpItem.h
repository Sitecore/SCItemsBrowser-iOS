#import <Foundation/Foundation.h>

/**
 A placeholder item that is added to the response dataset if the level is not a root one.
 Note : the dataset can contain only SCItem and SCLevelUpItem objects.
 
 It is handled differently both from the visual and from the logical perspective.
 As a user you should not create this class directly. You may need it only when sub-classing SCAbstractItemsBrowser.
 */
@interface SCLevelUpItem : NSObject
@end
