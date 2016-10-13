//
//  lowPassFilter.m
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 30/09/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.

#import "lowPassFilter.h"

#define kNumChannels 1

NSURL* lowPassFilter(NSURL* inFileURL) {
    
    ////////////////IMPORT//////////////////
    
    // Open the audio file in the given directory
    
    ExtAudioFileRef fileRef;
    ExtAudioFileOpenURL((__bridge CFURLRef)(inFileURL), &fileRef);
    
    AudioStreamBasicDescription inputFormat; //The clientFormat describes the input audio file
    
     // Specify the PCM format
     
     inputFormat.mSampleRate        = 8000.0;
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
    float *floatDataArray = (float *)malloc(sizeof(float) * 240000); //Make the array for holding samples big enough to hold 30s of recording at 8khz
    
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
    
    floatDataArray = (float *)realloc(floatDataArray, sizeof(float) * j); //This resizes the array to fit the amount of samples we actually use

    //printf("\nj is: %i",j);
    //printf("\nfloat[j] is: %f",floatDataArray[j-1]);
    
    //put filter code for the floatDataArray here
    /*
    for (int i=0; i<j-1;i++) {
        floatDataArray[i]= 0;
    }*/
    
    // Now we will put the data back into the audio buffer and make a new file
    //bufferList.mBuffers[0].mData = floatDataArray;
    
    //////////////////FILTER/////////////////
    
    float Fc = 2000.0;
    float Q = 1/sqrt(2);
    float samplingRate = 8000.0;
    
    float omega = 2*M_PI*Fc/samplingRate;
    float omegaS = sin(omega);
    float omegaC = cos(omega);
    float alpha = omegaS / (2*Q);
    
    
    float a0 = 1 + alpha;
    float b0 = ((1-omegaC)/2)   / a0;
    float b1 = ((1-omegaC))     / a0;
    float b2 = ((1-omegaC)/2)   / a0;
    float a1 = (-2 * omegaC)    / a0;
    float a2 = (1 - alpha)      / a0;
    
    float filter[5];
    filter[0] = b0;
    filter[1] = b1;
    filter[2] = b2;
    filter[3] = a1;
    filter[4] = a2;
    
    float *outputData = (float *)malloc(sizeof(float) * j);
    vDSP_deq22(floatDataArray, 1, filter, outputData, 1, j-2);
    
    //////////////AMPLIFY AND NORMALISE///////////////
    
    //Get abs max value
    float maxOutputValue = fabs(outputData[0]);
    for (int i=1;i<j;i++){
        if (fabs(outputData[i])>maxOutputValue){
            maxOutputValue = fabs(outputData[i]);
        }
    }
    
    //Normalise so that abs max = 1 nad everything else ranges from -1 to 1 (simultaneously amplifies)
    for (int i=0;i<j;i++){
        outputData[i] = outputData[i]/maxOutputValue;
    }
    
    
    ///////////////////EXPORT/////////////////
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *destName = @"output.caf";
    NSString * destPath = [basePath stringByAppendingPathComponent:destName];
    NSURL* destURL = [NSURL fileURLWithPath:destPath];
    
    EAFWrite *writer = [[EAFWrite alloc] init];
    [writer openFileForWrite:destURL sr:8000.0 channels:1 wordLength:32 type:kAudioFileCAFType];
    [writer writeFloats:j fromArray:outputData];
    
    free(outputBuffer);
    free(floatDataArray);
    free(outputData);

    return destURL;
}