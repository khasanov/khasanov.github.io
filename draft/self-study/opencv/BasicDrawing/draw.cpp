#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>

using namespace cv;

int main(int argc, char **argv) {

    static const int width = 400;
    static const int height = 400;
     Mat image = Mat::zeros(width, height, CV_8UC3);

     rectangle(image,
               Point(width / 6, height / 6),
               Point(width - width / 6, height - height / 6),
               Scalar(0, 255, 255),
               2 // thickness
              );

     imwrite("draw.jpg", image);
     static const char * const title = "BasicDrawing";
     namedWindow(title, WINDOW_AUTOSIZE);
     imshow(title, image);
     waitKey(0);
}
