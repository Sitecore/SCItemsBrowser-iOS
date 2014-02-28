#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@class SCItemRecord;
@class SCExtendedApiSession;

@interface SCItem (PrivateMethods)

-(instancetype)initWithRecord:( SCItemRecord* )record_
                   apiContext:( SCExtendedApiSession* )apiContext_;

@end
