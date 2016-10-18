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
void audioFingerprint(NSURL* inFileURL, BOOL fingerprintArray[][128*32*2]) {


    
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
    
    
    
    //////////////AMPLIFY AND NORMALISE///////////////
    
    //Get abs max value
    float maxOutputValue = fabs(floatDataArray[0]);
    for (int i=1;i<j;i++){
        if (fabs(floatDataArray[i])>maxOutputValue){
            maxOutputValue = fabs(floatDataArray[i]);
        }
    }
    
    //Normalise so that abs max = 1 nad everything else ranges from -1 to 1 (simultaneously amplifies)
    for (int i=0;i<j;i++){
        floatDataArray[i] = floatDataArray[i]/maxOutputValue;
    }
//////////////////////////CREATE WINDOWS WITH DATA/////////////////////////////////////
    
    int fftFrameSize = 2048;    //371ms frame at 5512 hz sample rate
    int fftFrameSpace = 64;     //11.6ms frame space at 5512 hz sample rate (overlap of each frame)
    
    int numFrames = ceil((((float)j - (float)fftFrameSize)/(float)fftFrameSpace)+1);
    
    float **specMatrix;   //dynamically allocates the 2D spectrogram matrix;
    specMatrix = (float **)malloc(sizeof(float *)*numFrames);
    for (int i=0;i<numFrames; i++){
        specMatrix[i] = (float *)malloc(sizeof(float)*(fftFrameSize/2));
    }
    
    
    
    
    
    
    int bufferlog2 = 11;
    FFTSetup fftSetup = vDSP_create_fftsetup(bufferlog2, kFFTRadix2); //allow for 2048 size window
    
    float outReal[fftFrameSize/2];
    float outImaginary[fftFrameSize/2];
    
    COMPLEX_SPLIT out = { .realp = outReal, .imagp = outImaginary };

    float tempFrame[fftFrameSize];
    
    
    for (int i=0; i<numFrames; i++) {
        //create temporary frame holding the sliding window values
        
        for (int p=0; p<fftFrameSize; p++) {
            tempFrame[p] = floatDataArray[(fftFrameSpace*i)+p];
            //printf("\n%i    out: %f     temp: %f",p,floatDataArray[p], tempFrame[p]);
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
    // Time 2: [    FFT    ]  there are 1024 elements across for each frequency
    // Time 3: [    FFT    ]  we want to simplify this into 32 frequency bins to improve speed
    // Time N: [    FFT    ]  the bins will be linearly spaced
    
    
    ///////////////REDUCE THE SPECTROGRAM MATRIX////////////////////
    
    int numBins = 32;

    float binSpace = (fftFrameSize/2)/numBins;

    
    
    float **smallSpec;   //dynamically allocates the 2D spectrogram matrix;
    smallSpec = (float **)malloc(sizeof(float *)*numFrames);
    for (int i=0;i<numFrames; i++){
        smallSpec[i] = (float *)malloc(sizeof(float)*numBins);
    }
    
    //intitialise the small spec to 0
    
    for (int a=0; a<numFrames; a++) {
        for (int b=0; b<numBins; b++) {
            smallSpec[a][b] = 0.0; //make everthing 0
        }
    }
    
    
    //reduce it
    float smallFrame[fftFrameSize/2];
    
    for (int i=0; i<numFrames; i++){
        
        for (int p=0; p<(fftFrameSize/2); p++) {
            smallFrame[p] = specMatrix[i][p]; //reuse the tempFrame to hold 1 row of the specMatrix
            //printf("\n %f",smallFrame[p]);
            
        }
        
        for (int j=0; j<numBins;j++) {
            for (int q=0; q<binSpace;q++) {
            
                smallSpec[i][j] += smallFrame[(32*j)+q];
            }
        }
        for (int j=0; j<numBins;j++) {
            //printf("\ni: %i   j: %i      out: %f",i,j,smallSpec[i][j]);
        }
    }
    
    
    /////////////////PERFORM WAVELET TRANSFORM ON ARRAY//////////////////////

    BOOL fingerprint[128*32*2]; //temp fingerprint to be put in the main fingerprint array
    
    float imageBlock[128][32];
    
    
    for (int i=0; i<floor(numFrames/128); i++) { //go down the array doing wavlet on each 128*32 block
        
        for (int a=0; a<128; a++) {
            for (int b=0; b<32; b++) {
                imageBlock[a][b] = smallSpec[a][b]; //create 128*32 block holding the reduced spectrogram data
            }
        }

        for (int j=0;j<128;j++){        //wavelet on the rows
            harrWavelet(imageBlock[j],32);
        }
        //put some code in here to do the colomms
        
        
        for (int q=0; q<32 ;q++) {    //wavelet on the columns
            
            float column[128];
        
            for (int j=0; j<128; j++) {
                column[j]=imageBlock[j][q];  //fill column array with a single column
            }
            
            harrWavelet(column, 128); //wavelet on the single col
            
            for (int j=0; j<128; j++) {
                imageBlock[j][q]=column[j];  //put the column back into the block
            }
            
        }
        //we have done the 2D wavelet on 128*32 block
        //now we get fingerprint and put in the fingerprint array
        memset(fingerprint, 0, sizeof(fingerprint));
        fingerprintGet(imageBlock, fingerprint);
        
        //put fingerprint in the main array
        
        for (int j=0; j<(128*32*2); j++) {
            fingerprintArray[i][j]= fingerprint[j];
        }
    }
    

    //we now have the fingerprint array
    //[fingerprint 1]
    //[fingerprint 2]
    //[fingerprint 3]
    //      etc

    //FREE THE MEMORY
    free(outputBuffer);
    free(floatDataArray);
    for (int i=0;i<numFrames; i++){ free(specMatrix[i]); }
    free(specMatrix);
    for (int i=0;i<numFrames; i++){ free(smallSpec[i]); }
    free(smallSpec);
    ExtAudioFileDispose(fileRef);
    vDSP_destroy_fftsetup(fftSetup);
}




void harrWavelet(float array[], int length) {
    
    float tmpRow[length];
    int inCount= length;
    

    while (inCount >1){
        inCount /= 2;
        
        for (int i=0; i<inCount; i++) {
            tmpRow[i]          = ((array[2*i] + array[2*i+1])/2.0);
            tmpRow[inCount+i]  = ((array[2*i] - array[2*i+1])/2.0);
        }
        
        for (int i=0; i<2*inCount; i++){
            array[i]=tmpRow[i];
        }
    }
}


void fingerprintGet(float image[128][32], BOOL fingerprint[]){
    
    int numRows=128;
    int numCols=32;
    
    float array[2][numRows*numCols];
    
    //create array holding all the image elements in 1 row and its indexes in the other row
    int index=0;
    for (int row =0; row<numRows; row++) {
        for (int col =0; col<numCols; col++) {
            array[0][index] = image[row][col];
            array[1][index] = index;
            //printf("\n%i",index);
            index++;
        }
    }
    //sort the array by magnitude and hold the index
    /*for (int i=0; i<200; i++) {
        printf("%f  ",array[0][i]);
    }*/
    
    //printf("\n\n\n");
    
    quickSort(array, 0, 128*32-1);

    /*for (int i=0; i<200; i++) {
        printf("%f  ",array[0][i]);
    }*/
    //first we need to extract top 200 wavelets
    
    for (int i=0; i<200; i++) {
        if (array[0][i]>0.0) {
            fingerprint[(int)(2*array[1][i])] = YES;
        }
        else if (array[0][i]<0.0) {
            fingerprint[(int)((2*array[1][i]))+1] = YES;
        }
        
    }
    
    
    
    
}


void quickSort( float a[2][128*32], int l, int r)
{
    int j;
    
    if( l < r )
    {
        // divide and conquer
        j = partition( a, l, r);
        quickSort( a, l, j-1);
        quickSort( a, j+1, r);
    }
    
}



int partition( float a[2][128*32], int l, int r) {
    int  i, j;
    float pivot, t, q;
    pivot = a[0][l];
    i = l; j = r+1;
    
    while( 1)
    {
        do ++i; while( a[0][i] <= pivot && i <= r );
        do --j; while( a[0][j] > pivot );
        if( i >= j ) break;
        t = a[0][i]; a[0][i] = a[0][j]; a[0][j] = t;
        q = a[1][i]; a[1][i] = a[1][j]; a[1][j] = q;
    }
    t = a[0][l]; a[0][l] = a[0][j]; a[0][j] = t;
    q = a[1][l]; a[1][l] = a[1][j]; a[1][j] = q;
    return j;
}














