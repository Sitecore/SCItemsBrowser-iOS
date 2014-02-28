#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@class SCItemRecord;
@class SCExtendedApiSession;

@interface SCItem (PrivateMethods)

-(instancetype)initWithRecord:( SCItemRecord* )record
                   apiSession:( SCExtendedApiSession* )apiSession;

@end
