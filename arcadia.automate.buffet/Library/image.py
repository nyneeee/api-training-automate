import subprocess
import os
from PIL import Image
from robot.libraries.BuiltIn import BuiltIn as builtin


class image():
    def compare_images(self, base_image: str, actual_image: str, output_image_name: str="", tolerance: int=3, return_result: bool=False) -> None or float:
        tolerance: float = float(tolerance/100)
        test_name: str = builtin().get_variable_value('$TEST_NAME')
        curdir: str = os.path.dirname(os.path.realpath(__file__))
        diff_path: str = os.path.join(curdir, '../../Different', test_name)
        
        # Create different directory
        if not os.path.exists(diff_path):
            os.makedirs(diff_path)
        
        # Create different image path
        if output_image_name:
            image_name = output_image_name
        else:
            image_name = "diff_point.png"
        d_path = os.path.join(diff_path, image_name)
        # difference: float = Imagemagick(base_image, actual_image, d_path).compare_images()
        
        # Compare image
        try:
            compare_cmd = 'magick compare -metric RMSE -subimage-search -dissimilarity-threshold 1.0 "%s" "%s" "%s"' \
                            % (base_image, actual_image, d_path)
            proc = subprocess.Popen(compare_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
            out, err = proc.communicate()
            # print('Comparison output: %s' % err)
            diff = err.split()[1][1:-1]
            difference = float("{:.2f}".format(float(diff)))
        except ValueError:
            builtin().fail('Could not parse comparison output: %s' % err)
        
        # Check compare result
        if return_result:
            return difference
        elif return_result == False and difference <= tolerance:
            builtin().log('Pass with discrepancy : ' + str(int(difference*100)))
        else:
            builtin().run_keyword('Fail', 'Image dissimilarity exceeds tolerance' + '\n' + 'Difference: ' + str(int(difference*100)))


    def crop_image(self, left:int, top:int, right:int, bottom:int, src_path: str, dst_path: str):
        img = Image.open(src_path)
        crop_img = img.crop((left, top, right, bottom))
        if not os.path.exists(dst_path):
            dirname: str = os.path.dirname(dst_path)
            os.makedirs(dirname, exist_ok=True)
        crop_img.save(dst_path)


# class Imagemagick(object):
#     def __init__(self, img1, img2, diff):
#         self.img1 = img1
#         self.img2 = img2
#         self.diff = diff

#     def compare_images(self):
#         compare_cmd = 'compare -metric RMSE -subimage-search -dissimilarity-threshold 1.0 "%s" "%s" "%s"' \
#                       % (self.img1, self.img2, self.diff)

#         attempts = 0
#         while attempts < 2:
#             proc = subprocess.Popen(compare_cmd,
#                                     stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)

#             out, err = proc.communicate()
#             # print('Comparison output: %s' % err)
#             diff = err.split()[1][1:-1]
#             trimmed = float("{:.2f}".format(float(diff)))
#             return trimmed

#             try:
#             except ValueError:
#                 if attempts == 0:
#                     print('Comparison failed first time. Output %s' % err)
#                     compare_cmd = 'magick ' + compare_cmd
#                 else:
#                     # raise Exception('Could not parse comparison output: %s' % err)
#                     return 
#                     builtin().fail('Could not parse comparison output: %s' % err)
#             finally:
#                 attempts += 1

if __name__ == '__main__':
    base_image = 'C:\\Users\\Karin\\Documents\\Git-Source\\Appium_Test\\ReferenceDetailPageEN\\Movie_Episode_Details_1_1_005_Favorites\\IconHeartEmpty.png'
    actual_image = 'C:\\Users\\Karin\\Documents\\Git-Source\\Appium_Test\\visual_images\\actual\\Movie_Episode_Details_1_1_005_Favorites\\IconHeartEmpty.png'
    image().compare_images(base_image=base_image, actual_image=actual_image)
