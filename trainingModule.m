%Step 1
%Membuat Penyimpanan data / datastore
imds = imageDatastore('pest_classification/training_dataset','IncludeSubfolders',true,...
        'LabelSource','foldernames');
    
    disp(imds); %menampilkannya pada command window
    
% %Step 2
% %Splitting the data
%{
membagi file gambar dalam imds menjadi dua datastore baru, imds1 dan imds2. 
Datastore imds1 baru berisi file p pertama dari setiap label dan imds2 berisi file yang tersisa
dari setiap label. p dapat berupa angka antara 0 dan 1 yang menunjukkan persentase file 
dari setiap label untuk ditetapkan ke imds1, atau bilangan bulat yang menunjukkan jumlah
absolut file dari setiap label untuk ditetapkan ke imds1.
    Example : [imds1,imds2] = splitEachLabel(imds,p)
%}
[traindata,testdata] = splitEachLabel(imds,0.8);

%Step 3
%layer Doc : https://www.mathworks.com/help/deeplearning/ref/nnet.cnn.layer.layer.html
layer = [imageInputLayer([333 500 3])
        convolution2dLayer(5,20)
        reluLayer
        maxPooling2dLayer(2, 'Stride', 2)
        fullyConnectedLayer(8)
        softmaxLayer
        classificationLayer
        ];
    
 %Step 4
 %Training options ( mengatur pengaturan training)'
 %trainingOption Doc : https://www.mathworks.com/help/deeplearning/ref/trainingoptions.html
 options = trainingOptions('rmsprop', ...
            'Plots', 'training-progress', ...
            'LearnRateSchedule', 'piecewise', ...
            'MaxEpochs',30, ...
            'LearnRateDropFactor', 0.4, ...
            'LearnRateDropPeriod',7, ...
            'MiniBatchSize', 30);
            %options.MaxEpochs = 30;
        
  %Step 5
  %Training the network
  [net,info] = trainNetwork(traindata,layer,options);
  
  save net net
  
  %Training completed
  
  helpdlg('Training completed');
 
 