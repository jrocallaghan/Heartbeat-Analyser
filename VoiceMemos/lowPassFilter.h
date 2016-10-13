//
//  lowPassFilter.h
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 30/09/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>
#include "EAFWrite.h"

NSURL* lowPassFilter(NSURL*inFileURL);