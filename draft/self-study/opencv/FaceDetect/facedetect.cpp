// http://docs.opencv.org/2.4/modules/objdetect/doc/cascade_classification.html?highlight=cascadeclassifier
// https://github.com/opencv/opencv/blob/master/samples/cpp/dbt_face_detection.cpp
// http://docs.opencv.org/master/d2/d64/tutorial_table_of_content_objdetect.html
#include "opencv2/objdetect.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"

#include <iostream>

using namespace cv;

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        std::cout << "Usage: facedetect /path/to/image\n" << std::endl;
        return -1;
    }

    static const char * const face_cascade_file = "haarcascade_frontalface_alt.xml";
    CascadeClassifier face_cascade;

    if (!face_cascade.load(face_cascade_file)) {
        std::cout << "Error loading face cascade\n";
        return -1;
    }

    Mat image = imread(argv[1], IMREAD_COLOR);
    if (image.empty())
    {
        std::cout << "No image data\n" << std::endl;
        return -1;
    }

    Mat image_gray;
    cvtColor(image, image_gray, COLOR_BGR2GRAY);
    equalizeHist(image_gray, image_gray);

    //-- Detect faces
    std::vector<Rect> faces;
    face_cascade.detectMultiScale(image_gray,
                                  faces,
                                  1.1, // scaleFactor
                                  2, // minNeighbours
                                  0 | CASCADE_SCALE_IMAGE,
                                  Size(30, 30) //minObjSize
                                   // maxObjSize
                                 );
    std::cout << "Detected " << faces.size() << " faces" << std::endl;
    for (int i = 0; i < faces.size(); ++i)
    {
        Rect face = faces[i];
        rectangle(image,
                  Point(face.x, face.y),
                  Point(face.x + face.width, face.y + face.height),
                  Scalar(0, 255, 255 ),
                  2);
    }
    static const char * const title = "FaceDetect";
    namedWindow(title, -1);
    imshow(title, image);
    waitKey(0);

     return 0;
}
