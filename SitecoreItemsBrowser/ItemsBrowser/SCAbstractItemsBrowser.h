#import <SitecoreItemsBrowser/SCItemsBrowserProtocol.h>
#import <SitecoreItemsBrowser/SCItemsBrowserInitialization.h>

#import <Foundation/Foundation.h>


/**
 An abstract items browser class. It is responsible for requesting levels asynchronously and notifying the delegate about user's actions.
 
 In order to implement your own component, you should 
 
 1. Subclass SCAbstractItemsBrowser
 2. Add a content view for items
 3. Implement the delegate and datasource methods of the content view.
 4. Implement the methods of the SCAbstractItemsBrowserSubclassing protocol and trigger the content view within them
 
 For details, please consider the implementation of 
 
 - SCItemListBrowser
 - SCItemGridBrowser
 
 */
@interface SCAbstractItemsBrowser : NSObject<SCItemsBrowserProtocol, SCItemsBrowserInitialization>


/**
 The session to communicate with the Sitecore instance. It can be set from code only.
 */
@property ( nonatomic, strong ) SCExtendedApiSession* apiSession;

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
