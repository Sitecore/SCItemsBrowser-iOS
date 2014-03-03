#import <Foundation/Foundation.h>

@class UIImage;
@class SCMediaCellController;


@protocol SCMediaCellEvents <NSObject>

-(void)didStartLoadingImageInMediaCellController:( SCMediaCellController* )sender;

-(void)mediaCellController:( SCMediaCellController* )sender
     didFinishLoadingImage:( UIImage* )image
                   forItem:( SCItem* )mediaItem;

-(void)mediaCellController:( SCMediaCellController* )sender
didFailLoadingImageForItem:( SCItem* )mediaItem
                 withError:( NSError* )error;
@end
