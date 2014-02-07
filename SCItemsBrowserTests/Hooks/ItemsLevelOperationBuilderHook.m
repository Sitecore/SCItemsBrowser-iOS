#import "ItemsLevelOperationBuilderHook.h"

#import <objc/message.h>
#import <objc/runtime.h>

#import "SCItemsFileManager.h"
#import "SCItemsFileManagerCallbacks.h"

@implementation ItemsLevelOperationBuilderHook
{
    BOOL _isHookEnabled;
 
    LevelOperationFromRequestBuilder _hookImpl;
    
    SEL _methodToHookSelector;
    Method _methodToHook;
    IMP _newImpl     ;
    IMP _originalImpl;
}

-(void)dealloc
{
    [ self disableHook ];
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithHookImpl:(LevelOperationFromRequestBuilder)hookImpl
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_hookImpl = hookImpl;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    self->_methodToHookSelector = @selector( levelLoaderFromRequest: );
#pragma clang diagnostic pop
    
    
    self->_methodToHook = class_getInstanceMethod( [ SCItemsFileManager class ], self->_methodToHookSelector );
    self->_originalImpl = class_getMethodImplementation( [ SCItemsFileManager class ], self->_methodToHookSelector );
    self->_newImpl = imp_implementationWithBlock( self->_hookImpl );

    return self;
}

-(void)enableHook
{
    if ( self->_isHookEnabled )
    {
        return;
    }

    method_setImplementation( self->_methodToHook, self->_newImpl );
    self->_isHookEnabled = YES;
}

-(void)disableHook
{
    if ( !self->_isHookEnabled )
    {
        return;
    }

    method_setImplementation( self->_methodToHook, self->_originalImpl );
    self->_isHookEnabled = NO;
}

@end
