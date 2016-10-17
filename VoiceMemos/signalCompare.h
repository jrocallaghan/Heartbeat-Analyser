//
//  signalCompare.h
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 7/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

//#ifndef signalCompare_h
//#define signalCompare_h
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>



void audioFingerprint(NSURL* inFileURL, BOOL fingerprintArray[][128*32*2]);
void harrWavelet(float array[], int length);
void fingerprintGet(float image[128][32], BOOL fingerprint[]);
void quickSort( float a[2][128*32], int l, int r);
int partition( float a[2][128*32], int l, int r);

//#endif /* signalCompare_h */
