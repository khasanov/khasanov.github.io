#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;

int main(int argc, char** argv)
{
    if (argc != 2)
    {
        std::cout << "Usage: hello /path/to/image\n" << std::endl;
        return -1;
    }

    Mat image = imread(argv[1], IMREAD_COLOR);
    if (image.empty())
    {
        std::cout << "No image data\n" << std::endl;
        return -1;
    }
    static const char * const title = "Hello, Lenna";
    namedWindow(title, WINDOW_AUTOSIZE);
    imshow(title, image);
    waitKey(0);
    return 0;
}
