//
//  PMTesseract.cpp
//  PMLib
//
//  Created by Kevin Calcote on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "PMPlate.h"
#include <leptonica/environ.h>
#include <leptonica/pix.h>
#include <tesseract/baseapi.h>

namespace PMLibCpp
{
    //Constructor
    PMPlate::PMPlate()
    {
        tesseract = new tesseract::TessBaseAPI();
    }
    
    //Destructor
    PMPlate::~PMPlate()
    {
    }
    
    void PMPlate::Init(const char* datapath, const char* language)
    {
        tesseract->Init(datapath, language);
    }
    
    void PMPlate::SetPlateImage(const unsigned char* imagedata, int width, int height, int bytes_per_pixel, int bytes_per_line)
    {
        tesseract->SetImage(imagedata, width, height, bytes_per_pixel, bytes_per_line);
    }
    
    char* PMPlate::GetPlateText()
    {
        tesseract->Recognize(NULL);
        
        return tesseract->GetUTF8Text();
    }
}