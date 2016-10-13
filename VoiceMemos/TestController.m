//
//  TestController.m
//  
//
//  Created by Jordan O'Callaghan on 18/08/2016.
//
//

#import "TestController.h"
#import "LBAudioDetective.h"
#import "LBAudioDetectiveFrame.h"

@interface TestController ()

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testButton:(UIButton *)sender {
    
    
    NSString *firstFilePath = [[NSBundle mainBundle] pathForResource:@"normal"
                                                              ofType:@"mp3"];
    NSURL *firstURL = [NSURL fileURLWithPath:firstFilePath];
    
    NSString *secondFilePath = [[NSBundle mainBundle] pathForResource:@"innocent"
                                                              ofType:@"mp3"];
    NSURL *secondURL = [NSURL fileURLWithPath:secondFilePath];
    
    
    
    LBAudioDetectiveRef detective = LBAudioDetectiveNew();
    Float32 match = 0.0f;
    LBAudioDetectiveCompareAudioURLs(detective, firstURL, secondURL, 0, &match);
    NSLog(@"The files are equal to a percentage of %f", match);
    LBAudioDetectiveDispose(detective);
    
}

@end
