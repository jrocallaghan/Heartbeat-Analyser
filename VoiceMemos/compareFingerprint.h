//
//  compareFingerprint.h
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 16/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

#ifndef compareFingerprint_h
#define compareFingerprint_h
#include "signalCompare.h"
#include "LBAudioDetective.h"
#include "LBAudioDetectiveFrame.h"

float compareFingerprint(NSURL* inFileURL1, NSURL* inFileURL2);
int getFingerprintLength(NSURL* inFileURL);
float compareSubfingerprint(BOOL subfingerprint1[], BOOL subfingerprint2[]);
#endif /* compareFingerprint_h */
