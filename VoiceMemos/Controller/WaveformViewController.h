/*//
//  WaveformViewController.h
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 12/09/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <EZAudio/EZAudio.h>

@interface WaveformViewController : UIViewController

//
// The EZAudioFile representing of the currently selected audio file

//
@property (nonatomic,strong) EZAudioFile *audioFile;

@property NSURL *inputURL;
//
// The CoreGraphics based audio plot
//
@property (weak, nonatomic) IBOutlet EZAudioPlot *audioPlot;

//
// A label to display the current file path with the waveform shown
//
@property (nonatomic,weak) IBOutlet UILabel *filePathLabel;

@end
*/