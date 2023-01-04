a = imread('pest_classification/normal/Image_76.jpg');
figure,imshow(a);
b = imresize(a,[256 256]);
figure, imshow(b);
imwrite(b,'leaf1.jpg');