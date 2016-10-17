//
//  compareFingerprint.m
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 16/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "compareFingerprint.h"

#define kSamplingRate 5512.0
#define kNumChannels 1


void compareFingerprint(NSURL* inFileURL1, NSURL* inFileURL2) {

    int length1 = getFingerprintLength(inFileURL1);
    if (length1 == 0){ //make sure we have enough data for a single fingerprint
        printf("not enough data, record for more than 1.5 seconds!");
        return; //exit the function if we dont have a enough fingerprint
    }
    BOOL fingerprintArray1[length1][128*32*2];
    audioFingerprint(inFileURL1, fingerprintArray1);
    
    
    
    int length2 = getFingerprintLength(inFileURL2);
    if (length2 == 0){ //make sure we have enough data for a single fingerprint
        printf("not enough data, record for more than 1.5 seconds!");
        return; //exit the function if we dont have a enough fingerprint
    }
    BOOL fingerprintArray2[length2][128*32*2];
    audioFingerprint(inFileURL2, fingerprintArray2);
    
    
    int offset = 0;
    float match = 0.0;

    
    if (length1>length2) { //array 2 is smaller, slide it along array 1
        while (offset <= length1-length2) {
            float matchSum = 0.0;
            for (int i=0; i<length2; i++) {
                float currentMatch = compareSubfingerprint(fingerprintArray1[i], fingerprintArray2[i+offset]);
                matchSum += currentMatch;
            }
            match = MAX(match, matchSum/(float)length2);
        }
    }
    else if (length1<length2) { //array 1 is smaller, slide it along array 2
        while (offset <= length2-length1) {
            float matchSum = 0.0;
            for (int i=0; i<length2; i++) {
                float currentMatch = compareSubfingerprint(fingerprintArray2[i], fingerprintArray1[i+offset]);
                matchSum += currentMatch;
            }
            match = MAX(match, matchSum/(float)length1);
        }
    }
    else if (length1==length2) { //array 1 and 2 are same size
        for (int i=0; i<length1; i++) {
            float currentMatch = compareSubfingerprint(fingerprintArray1[i], fingerprintArray2[i]);
            match += currentMatch;
        }
        match=match/(float)length1;
    }
    
    
    
    printf("\nMatch: %f",match);
    
    //printf("\nlength: %i   %i\n\n",length1,length2);
    
    
    
    
    /*
    
    for (int i=0; i<length1;i++) {
        for (int j=0; j<(200); j++) {
            printf("\n%i  %i",fingerprintArray1[i][j],fingerprintArray1[i][j]);
        }
        printf("\n\n\n");
    }
    */
    
}

float compareSubfingerprint(BOOL subfingerprint1[], BOOL subfingerprint2[]) {
    
    int hits = 0;
    int possibleHits = 0;
    for (int i=0; i<(128*32*2); i+=2) {
        BOOL sf1s1 = subfingerprint1[i];
        BOOL sf1s2 = subfingerprint1[i+1];
        
        if (sf1s1 ||sf1s2) { //if either value is 1 we check for hit, otherwise no point looking
            possibleHits++;
            
            BOOL sf2s1 = subfingerprint2[i];
            BOOL sf2s2 = subfingerprint2[i+1];

            if ((sf1s1 == sf2s1) && (sf1s2 == sf2s2)) {
                hits++;
            }
        }
    }
    return (float)hits/(float)possibleHits; //the number of correct matches
}






int getFingerprintLength(NSURL* inFileURL) {

    ////////////////IMPORT//////////////////
    
    // Open the audio file in the given directory
    
    ExtAudioFileRef fileRef;
    ExtAudioFileOpenURL((__bridge CFURLRef)(inFileURL), &fileRef);
    
    AudioStreamBasicDescription inputFormat; //The clientFormat describes the input audio file
    
    // Specify the PCM format
    
    inputFormat.mSampleRate        = kSamplingRate;
    inputFormat.mFormatID          = kAudioFormatLinearPCM;
    inputFormat.mFormatFlags       = kLinearPCMFormatFlagIsFloat;
    inputFormat.mChannelsPerFrame  = 1;
    inputFormat.mBytesPerPacket    = sizeof(Float32);
    inputFormat.mBytesPerFrame     = sizeof(Float32);
    inputFormat.mFramesPerPacket   = 1;
    inputFormat.mBitsPerChannel    = sizeof(Float32) * 8;
    
    // Specify the format we want to read it with (PCM)
    ExtAudioFileSetProperty(fileRef, kExtAudioFileProperty_ClientDataFormat, sizeof(AudioStreamBasicDescription), &inputFormat);
    
    // Get the length of the audio file
    
    UInt32 propertySize = sizeof(SInt64);
    SInt64 dataLength = 0;
    ExtAudioFileGetProperty(fileRef, kExtAudioFileProperty_FileLengthFrames, &propertySize, &dataLength);
    
    
    // Calculate the number of frames needed
    /*
     
     UInt32 numberFrames = inDetective->windowSize;
     
     Float32 samples[numberFrames]; // A large enough size to not have to worry about buffer overrun
     */
    
    int numSamples = 1024;
    UInt32 sizePerPacket = sizeof(Float32);
    UInt32 packetsPerBuffer = numSamples;
    UInt32 outputBufferSize = packetsPerBuffer * sizePerPacket;
    
    UInt8 *outputBuffer = (UInt8 *)malloc(sizeof(UInt8 *) * outputBufferSize);
    
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mData = outputBuffer;
    bufferList.mBuffers[0].mNumberChannels = 1;
    bufferList.mBuffers[0].mDataByteSize = outputBufferSize;
    
    UInt32 frameCount = numSamples;
    float *samplesAsCArry;
    int j = 0;
    float *floatDataArray = (float *)malloc(sizeof(float) * (30*kSamplingRate));
    //Make the array for holding samples big enough to hold 30s of recording at 5512hz
    
    while (frameCount > 0) {
        ExtAudioFileRead(fileRef, &frameCount, &bufferList);
        if (frameCount > 0) {
            AudioBuffer audioBuffer = bufferList.mBuffers[0];
            samplesAsCArry = (float *)audioBuffer.mData;
            
            for (int i = 0; i<1024; i++) {
                floatDataArray[j] = (double)samplesAsCArry[i];
                //printf("\n%i   %f",j,floatDataArray[j]);
                j++;
            }
        }
    }
    //////////////////////////CREATE WINDOWS WITH DATA/////////////////////////////////////
    
    int fftFrameSize = 2048;    //371ms frame at 5512 hz sample rate
    int fftFrameSpace = 64;     //11.6ms frame space at 5512 hz sample rate (overlap of each frame)
    
    int numFrames = ceil((((float)j - (float)fftFrameSize)/(float)fftFrameSpace)+1);
    
    
    
    int fingerprintArraySize=0;
    for (int i=0; i<floor(numFrames/128); i++) {
        fingerprintArraySize++;
    }
    
    //FREE THE MEMORY
    free(outputBuffer);
    free(floatDataArray);
    ExtAudioFileDispose(fileRef);

    
    
    return fingerprintArraySize;
    
}
