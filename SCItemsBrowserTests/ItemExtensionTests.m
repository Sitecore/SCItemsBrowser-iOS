#import <XCTest/XCTest.h>

#import <SCItemsBrowser/SCItemsBrowser.h>

#import "SCItem+Media.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

#import <MobileSDK-Private/SCItemRecord_Source.h>
#import <MobileSDK-Private/SCItem+PrivateMethods.h>


@interface ItemExtensionTests : XCTestCase
@end

@implementation ItemExtensionTests
{
    SCItem      * _rootItem                 ;
    SCItemRecord* _rootRecord               ;
    
    SCItem      * _mediaImageItem           ;
    SCItemRecord* _mediaImageRecord         ;
    
    SCItem      * _mediaItemOutsideLibrary  ;
    SCItemRecord* _mediaRecordOutsideLibrary;
    
    SCItem      * _folderItemInsideLibrary  ;
    SCItemRecord* _folderRecordInsideLibrary;
}

-(void)setUp
{
    [ super setUp ];
    
    SCItemRecord* newRecord  = nil;
    

    newRecord = [ SCItemRecord new ];
    {
        newRecord.displayName  = @"хомяк"                 ;
        newRecord.path         = @"/sitecore/content/home";
        newRecord.itemTemplate = @"common/folder"         ;
    }
    self->_rootRecord = newRecord;
    self->_rootItem   = [ [ SCItem alloc ] initWithRecord: self->_rootRecord
                                               apiContext: nil ];
    
    
    newRecord = [ SCItemRecord new ];
    {
        newRecord.displayName  = @"grumpy cat.jpg"                      ;
        newRecord.path         = @"/sitecore/media library/grumpy cat"  ;
        newRecord.itemTemplate = @"system/media/unversioned/image"      ;
    }
    self->_mediaImageRecord = newRecord;
    self->_mediaImageItem   = [ [ SCItem alloc ] initWithRecord: self->_mediaImageRecord
                                                     apiContext: nil ];

    
    newRecord = [ SCItemRecord new ];
    {
        newRecord.displayName  = @"facepalm.jpg"                       ;
        newRecord.path         = @"/sitecore/content/home/facepalm.jpg";
        newRecord.itemTemplate = @"system/media/unversioned/image";
    }
    self->_mediaRecordOutsideLibrary = newRecord;
    self->_mediaItemOutsideLibrary   =
    [ [ SCItem alloc ] initWithRecord: self->_mediaRecordOutsideLibrary
                           apiContext: nil ];
    
    
    newRecord = [ SCItemRecord new ];
    {
        newRecord.displayName  = @"logo logo icons"                   ;
        newRecord.path         = @"/sitecore/media library/logo icons";
        newRecord.itemTemplate = @"COMMON/FOLDER"                     ;
    }
    self->_folderRecordInsideLibrary = newRecord;
    self->_folderItemInsideLibrary   =
    [ [ SCItem alloc ] initWithRecord: self->_folderRecordInsideLibrary
                           apiContext: nil ];
    
}

-(void)tearDown
{
    self->_rootItem                   = nil;
    self->_rootRecord                 = nil;
    self->_mediaImageItem             = nil;
    self->_mediaImageRecord           = nil;
    self->_mediaItemOutsideLibrary    = nil;
    self->_mediaRecordOutsideLibrary  = nil;
    self->_folderItemInsideLibrary    = nil;
    self->_folderRecordInsideLibrary  = nil;
    
    [ super tearDown ];
}

-(void)testMediaItemDetection
{
    XCTAssertFalse( [ self->_rootItem                isMediaItem ], @"_rootItem       misamatch"          );
    XCTAssertTrue ( [ self->_mediaImageItem          isMediaItem ], @"_mediaImageItem misamatch"          );
    XCTAssertFalse( [ self->_mediaItemOutsideLibrary isMediaItem ], @"_mediaItemOutsideLibrary misamatch" );
    XCTAssertTrue ( [ self->_folderItemInsideLibrary isMediaItem ], @"_folderItemInsideLibrary misamatch" );
}

-(void)testImageDetection
{
    XCTAssertFalse( [ self->_rootItem                isImage ], @"_rootItem       misamatch"          );
    XCTAssertTrue ( [ self->_mediaImageItem          isImage ], @"_mediaImageItem misamatch"          );
    XCTAssertTrue ( [ self->_mediaItemOutsideLibrary isImage ], @"_mediaItemOutsideLibrary misamatch" );
    XCTAssertFalse( [ self->_folderItemInsideLibrary isImage ], @"_folderItemInsideLibrary misamatch" );
}

-(void)testMediaImageDetection
{
    XCTAssertFalse( [ self->_rootItem                isMediaImage ], @"_rootItem       misamatch"          );
    XCTAssertTrue ( [ self->_mediaImageItem          isMediaImage ], @"_mediaImageItem misamatch"          );
    XCTAssertFalse( [ self->_mediaItemOutsideLibrary isMediaImage ], @"_mediaItemOutsideLibrary misamatch" );
    XCTAssertFalse( [ self->_folderItemInsideLibrary isMediaImage ], @"_folderItemInsideLibrary misamatch" );
}


@end
