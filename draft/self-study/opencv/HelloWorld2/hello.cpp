#include <string>
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

    Mat gray_image;
    cvtColor(image, gray_image, COLOR_BGR2GRAY);
    std::string gray_name = std::string("gray_").append(argv[1]);
    imwrite(gray_name.c_str(), gray_image);
    static const char * const title = "Hello, Lenna Gray";
    namedWindow(title, WINDOW_AUTOSIZE);
    imshow(title, gray_image);
    waitKey(0);
    return 0;
}
