#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@class SCItemRecord;
@class SCExtendedApiSession;

@interface SCItem (PrivateMethods)

-(instancetype)initWithRecord:( SCItemRecord* )record_
                   apiSession:( SCExtendedApiSession* )apiContext_;

@end
