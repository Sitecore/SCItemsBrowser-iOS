#ifndef SCItemsBrowser_SCItemRecord_Source_h
#define SCItemsBrowser_SCItemRecord_Source_h

@class SCItemSourcePOD;

#import <MobileSDK-Private/SCItemRecord_UnitTest.h>

@interface SCItemRecord (SCItemSource)

-(SCItemSourcePOD*)getSource;

-(SCItemSourcePOD*)itemSource;
-(void)setItemSource:(SCItemSourcePOD*)itemSource;

@end


#endif
