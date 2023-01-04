load net
%{ membuat 2 variabel 'filename' dan 'pathname' dengan valuenya sebuah fungsi uigetfile. %}
%uigetfile digunakan mencari file atau Open file
[filename, pathname] = uigetfile('*.*');

if isequal(filename,0) || isequal(pathname,0)
       warndlg('User pressed cancel')
else
       %fungsi strcat untuk menyatukan dua variabel string
       %fungsi imread untuk membaca file gambar dalam bentuk matrix
       
       g = imread(strcat( pathname,filename));
       g = imresize(g,[333 500]); %mengubah size gambar
       figure('Renderer', 'painters', 'Position', [150 45 1280 720])
       %figure,imshow(g);
       %melakukan subplot(1,2,1); atau subplot(121); , Anda ingin memiliki angka senilai satu baris dan dua kolom. Angka terakhir, p=1 berarti Anda ingin menempatkan plot di kolom paling kiri. 21 Jun 20
       subplot(4,4,1); imshow(g); title("Original Image")
       label = classify(net,g);
       labelStr = string(label);
       %disp(label);
end

a = imread(strcat( pathname,filename));
a = imresize(a,[256 256]);

c = rgb2hsv(a); %mengkonversi nilai RGB ke HSV image
%figure, imshow(a)
%figure, imshow(c)

H = c(:,:,1);
S = c(:,:,2);
V = c(:,:,3);

f = fspecial('gaussian', [9,9]);
filter = imfilter(H, f);
subplot(4,4,2); imshow(filter); title("Filter Image")

if all(labelStr == 'Apoderus_javanicus')
    bw = filter > 0.17 & filter <0.65;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 1000]);
    %figure, imshow(Bw)
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
    %subplot(3,3,6); imshow(sebab); title(labelStr)
elseif labelStr == 'Aulacaspis_tubercularis' 
    bw = filter > 0.15 & filter <0.5;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 1000]);
    %figure, imshow(Bw)
    
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
elseif labelStr == 'Ceroplastes_rubens' 
    bw = filter > 0.08 & filter <0.5;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 600]);
    %figure, imshow(Bw)
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
elseif labelStr == 'Cisaberoptus_kenyae' 
    bw = filter > 0.08 & filter <0.3;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 2000]);
    %figure, imshow(Bw)
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
elseif labelStr == 'Dappula_tertia' 
    bw = filter > 0.15 & filter <0.5;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 1000]);
    %figure, imshow(Bw)
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
elseif labelStr == 'Dialeuropora_decempuncta' 
    bw = filter > 0.08 & filter <0.3;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 2000]);
    %figure, imshow(Bw)
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
elseif labelStr == 'Erosomyia_sp' 
    bw = filter > 0.1 & filter <0.55;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 1000]);
    %figure, imshow(Bw)
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
elseif labelStr == 'Icerya_seychellarum' 
    bw = filter > 0.15 & filter <0.5;
    Bw = ~bw;
    BW2 = bwareafilt(Bw,[5 600]);
    %figure, imshow(Bw)
    subplot(4,4,3); imshow(Bw); title("Binarized Image")
    subplot(4,4,4); imshow(BW2); title("Image with Spots")
    
end

%title(labelStr);
cc = bwconncomp(BW2);
Spots = cc.NumObjects ;
%disp(Spots)

fisObject = readfis("FuzzyLeaf.fis");
fis = getFISCodeGenerationData(fisObject);

opt = evalfisOptions('NumSamplePoints',51);
evalfisOutput = evalfis(fis, Spots, opt);
%plotfis(fisObject)

%---------- MENAMPILKAN TEXT DI BAWAH GAMBAR -------------  
sebab = imread(strcat('D:\DATA KULIAH\Semester 7\Pengolahan Citra\UAS\UAS-PengolahanCitra\DatasetMangga\Penyebab\', labelStr,'.jpg'));
subplot(4,4,5); 
imshow(sebab);
title('Penyebab');
%textbox [kanan,bawah,kiri,atas]
annotation('textbox', [0.13 0.08 0.8 0.46], ...
    'String', strcat('Penyakit pada daun Disebabkan Oleh ( ', labelStr,' )'), ...
    'Color', [1 0.5 0], ...
    'FontWeight', 'bold', ...
    'EdgeColor', 'none');

annotation('textbox', [0.13 0.03 0.8 0.45], ...
    'String', strcat('Kesehatan ( ', num2str(evalfisOutput), '% )'), ...
    'Color', [0 0.5 0], ...
    'FontWeight', 'bold', ...
    'EdgeColor', 'none')


x = ['Penyakit pada daun disebabkan oleh:', label];
y = ['     Kesehatan ', num2str(evalfisOutput), '%'];
disp(x)
disp(y)
