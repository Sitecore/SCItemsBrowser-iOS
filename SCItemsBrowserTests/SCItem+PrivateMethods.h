#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@class SCItemRecord;
@class SCExtendedApiContext;

@interface SCItem (PrivateMethods)

-(instancetype)initWithRecord:( SCItemRecord* )record_
                   apiContext:( SCExtendedApiContext* )apiContext_;

@end
