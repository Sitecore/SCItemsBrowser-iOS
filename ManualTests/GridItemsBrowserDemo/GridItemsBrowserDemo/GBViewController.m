#import "GBViewController.h"

@interface GBViewController ()<SCItemsBrowserDelegate, SIBGridModeAppearance, SIBGridModeCellFactory>

@property (strong, nonatomic) IBOutlet SCItemGridBrowser *itemsBrowser;
@property (strong, nonatomic) IBOutlet SIBAllChildrenRequestBuilder *requestBuilder;


@end

@implementation GBViewController

-(void)viewDidLoad
{
    [ super viewDidLoad ];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ];
    // Dispose of any resources that can be recreated.
}

@end
