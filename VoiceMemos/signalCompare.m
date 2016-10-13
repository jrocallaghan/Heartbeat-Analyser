//
//  signalCompare.m
//  VoiceMemos
//
//  Created by Jordan O'Callaghan on 7/10/2016.
//  Copyright © 2016 Zhouqi Mo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "signalCompare.h"
#import <math.h>

#define kSamplingRate 5512.0
#define kNumChannels 1
OSStatus audioFingerprint(NSURL* inFileURL) {


    
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
    float samplingRate = kSamplingRate;
    
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
//////////////////////////CREATE WINDOWS WITH DATA/////////////////////////////////////
    
    int fftFrameSize = 2048;    //371ms frame at 5512 hz sample rate
    int fftFrameSpace = 64;     //11.6ms frame space at 5512 hz sample rate (overlap of each frame)
    
    int numFrames = ceil(((j - fftFrameSize)/fftFrameSpace)+1);
    
    float **specMatrix;   //dynamically allocates the 2D spectrogram matrix;
    specMatrix = (float **)malloc(sizeof(float *)*numFrames);
    for (int i=0;i<numFrames; i++){
        specMatrix[i] = (float *)malloc(sizeof(float)*(fftFrameSize/2));
    }
    
    
    
    
    
    
    int bufferlog2 = 11;
    FFTSetup fftSetup = vDSP_create_fftsetup(bufferlog2, kFFTRadix2); //allow for 2048 size window
    
    float outReal[fftFrameSize/2];
    float outImaginary[fftFrameSize/2];
    
    /*printf("\n\ntest 1\n");
    for (int i=0; i<1024; i++) {
        printf("\n%i       %f",i,outReal[i]);
    }*/
    
    COMPLEX_SPLIT out = { .realp = outReal, .imagp = outImaginary };


    //float *tempFrame = (float *)malloc(sizeof(float) * fftFrameSize);
    float tempFrame[fftFrameSize];
    

    
    
    for (int i=0; i<numFrames; i++) {
        //create temporary frame holding the sliding window values
        
        for (int p=0; p<fftFrameSize; p++) {
            tempFrame[p] = outputData[(fftFrameSpace*i)+p];
            //printf("\n%i    out: %f     temp: %f",p,outputData[p], tempFrame[p]);
        }
        
        
        //do the spectrogram
        vDSP_ctoz((COMPLEX *)tempFrame, 2, &out, 1, fftFrameSize/2);
        vDSP_fft_zrip(fftSetup, &out, 1, bufferlog2, FFT_FORWARD);
        
        
        for (int j=0; j<1024; j++) {
            //get magnitude or results and feed into array
            specMatrix[i][j] =  sqrt((outReal[j]*outReal[j]) + (outImaginary[j]*outImaginary[j]));
            //printf("\ni: %i   j: %i      out: %f",i,j,specMatrix[i][j]);
        }
             
    }
    
    // We now have specMatrix that looks like this:
    // Time 1: [    FFT    ]  where FFT is the FFT frame holding all the frequencies magnitudes
    // Time 2: [    FFT    ]  there are 2048 elements across for each frequency
    // Time 3: [    FFT    ]  we want to simplify this into 32 frequency bins to improve speed
    // Time N: [    FFT    ]  the bins will be linearly spaced
    
    int numBins = 32;

    float binSpace = fftFrameSize/numBins;

    
    
    float **smallSpec;   //dynamically allocates the 2D spectrogram matrix;
    specMatrix = (float **)malloc(sizeof(float *)*numFrames);
    for (int i=0;i<numFrames; i++){
        smallSpec[i] = (float *)malloc(sizeof(float)*numBins);
    }
    
    //smallSpec = {{0,0},{0,0}};
    
    
    for (int i=0; i<numFrames; i++){
        
        for (int p=0; p<fftFrameSize; p++) {
            tempFrame[p] = specMatrix[i][p]; //reuse the tempFrame to hold 1 row of the specMatrix
            
        }
        
        for (int j=0; j<numFrames;j++) {
        
        
            for (int q=0; q<binSpace;q++) {
            
                smallSpec[i][j] += tempFrame[q];
            }
            printf("\ni: %i   j: %i      out: %f",i,j,smallSpec[i][j]);
        }
    }
    
    
    /////////////////PERFORM WAVELET TRANSFORM ON ARRAY//////////////////////
    float tmp[numBins];
    int inCount= numBins;
    
    for (int j=0; j<numFrames; j++) {
        
        while (inCount >1){
            inCount /= 2;
        
            for (int i=0; i<inCount; i++) {
                tmp[i]          = ((smallSpec[j][2*i] + smallSpec[j][2*i+1])/2.0);
                tmp[inCount+i]  = ((smallSpec[j][2*i] - smallSpec[j][2*i+1])/2.0);
            }
        
            for (int i=0; i<2*inCount; i++){
                smallSpec[j][i]=tmp[i];
            }
        }
    }
    
    ////////////////////////////HASH DATA////////////////////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    printf("\ndone");
    return 0;
    
}
