//
//  PMTesseract.h
//  PMLib
//
//  Created by Kevin Calcote on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef PMLib_PMPlate_h
#define PMLib_PMPlate_h

namespace tesseract {
    class TessBaseAPI;
};

namespace PMLibCpp
{
    class PMPlate
    {
    public:
        PMPlate();
        ~PMPlate();
        void Init(const char* datapath, const char* language);
        void SetPlateImage(const unsigned char* imagedata, int width, int height, int bytes_per_pixel, int bytes_per_line);
        char* GetPlateText();
    private:
        tesseract::TessBaseAPI *tesseract;
    };
};

#endif
