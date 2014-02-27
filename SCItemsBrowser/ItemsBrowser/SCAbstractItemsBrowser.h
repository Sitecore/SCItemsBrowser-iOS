#import <SCItemsBrowser/SCItemsBrowserProtocol.h>
#import <SCItemsBrowser/SCItemsBrowserInitialization.h>

#import <Foundation/Foundation.h>


@interface SCAbstractItemsBrowser : NSObject<SCItemsBrowserProtocol, SCItemsBrowserInitialization>


/**
 The context to communicate with the Sitecore instance. It can be set from code only.
 */
@property ( nonatomic, strong ) SCExtendedApiContext* apiContext;

/**
 An item to start browsing with. It can be set from code only.
 */
@property ( nonatomic, strong ) SCItem*               rootItem  ;

/**
 Set this object to perform filtration by template or any other criteria.
 It can be set from the Interface Builder. For default behaviour (getting all children of the item) please use an instance of the SIBAllChildrenRequestBuilder class.
 */
@property ( nonatomic, weak   ) IBOutlet id<SCItemsLevelRequestBuilder> nextLevelRequestBuilder;

/**
 A delegate that gets notifications about levels loading.
 It can be set from the Interface Builder.
 */
@property ( nonatomic, weak   ) IBOutlet id<SCItemsBrowserDelegate> delegate;

@end
