clc;
clear;
close all;


%versions = {'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL', ...
%            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL_NO_FLAG'};
versions = {'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL', ...
            'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL_NO_FLAG'};

%Variabile per errore su un keypoint specifico
ERR_x = zeros(2, 3680);
ERR_y = zeros(2,3680);
numkey = 21;

for v = 1:length(versions)
    
    [confidence, keypoints_pred, keypoints_true, missed_detection, false_detection] = function_estrazione_dati_singolo_key(versions{v}, ...
        'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize');
        %'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize');        
    coordinate_x = zeros(3680, 33);
    coordinate_y = zeros(3680, 33);
    coordinate_x_true = zeros(3680, 33);
    coordinate_y_true = zeros(3680, 33);
    
    for k = 1:3680
        i = 1;
        j = 0;
        while i < length(keypoints_pred(k,:))
            j = j + 1;
            coordinate_x(k, j) = keypoints_pred(k, i);
            coordinate_x_true(k, j) = keypoints_true(k, i);
            i = i + 2;
        end
        s = 2;
        t = 0;
        while s <= length(keypoints_pred(k,:))
            t = t + 1;
            coordinate_y(k, t) = keypoints_pred(k, s);
            coordinate_y_true(k, t) = keypoints_true(k, s);
            s = s + 2;
        end
        if coordinate_x(k,numkey)==-1
            ERR_x(v,k)=-1;
            ERR_y(v,k)=-1;
        else
            ERR_x(v,k) = abs(coordinate_x(k, numkey) * 640 - coordinate_x_true(k , numkey) * 640);
            ERR_y(v,k) = abs(coordinate_y(k, numkey) * 640 - coordinate_y_true(k, numkey) * 640);
        end
    end
end


%%PLOT DI ERRORI FISSATO UNO DEI KEYPOINTS

figure;
subplot(2, 1, 1);
plot(1:3680, ERR_x(1,:), '-r');
hold on;
plot(1:3680, ERR_y(1,:), '-b');
hold off;
title('YOLOv8 SMALL');
xlabel('Frame');
ylabel('Error (pix)');
xlim([1 3680]);
ylim([0 max([ERR_x(:); ERR_y(:)])]);
legend('X-axis error', 'Y-axis error');


subplot(2, 1, 2);
plot(1:3680, ERR_x(2,:), '-r');
hold on;
plot(1:3680, ERR_y(2,:), '-b');
hold off;
title('YOLOv8 SMALL no flag');
xlabel('Frame');
ylabel('Error (pix)');
xlim([1 3680]);
ylim([0 max([ERR_x(:); ERR_y(:)])]);
legend('X-axis error', 'Y-axis error');



%%CALCOLO MEDIA NON TENENDO CONTO DELLE FALSE/MISSED DETECTION
mediaX=zeros(2,1);
mediaY=zeros(2,1);
std_x=zeros(2,1);
std_y=zeros(2,1);
WRONG=zeros(2,1);

figure;
j=0;
for i=1:length(versions)
    k=1;
    err_x=ERR_x(i,:);
    err_y=ERR_y(i,:);
    wrong = find(err_x == -1);
    WRONG(i)=length(wrong);
    err_x(wrong) = [];
    err_y(wrong) = [];

    %Delete outside FOV keypoints
    err_x=nonzeros(err_x);
    err_y=nonzeros(err_y);
    
    mediaX(i)=mean(err_x);
    mediaY(i)=mean(err_y);
    std_x(i)=std(err_x);
    std_y(i)=std(err_y);

    %HISTOGRAMS
    subplot(2 ,2 ,2*j+1);
    histogram(err_x, 'BinWidth', 1, 'FaceColor','r');
    versions_name={'SMALL', 'SMALL no flag'};
    title(['YOLOv8 ' versions_name{i}]);
    xlabel('X-axis error (pix)');
    ylabel('Number of occurances');
    subtitle(['Mean = ' num2str(mediaX(i)) ' Standard deviation = ' num2str(std_x(i)), ' Missed/false detections: ', num2str(WRONG(i))]);
    
    subplot(2 ,2 ,i*2);
    histogram(err_y, 'BinWidth', 1, 'FaceColor','b');
    title(['YOLOv8 ' versions_name{i}]);
    xlabel('Y-axis error (pix)');
    ylabel('Number of occurances');
    subtitle(['Mean = ' num2str(mediaY(i)) ' Standard deviation = ' num2str(std_y(i)), ' Missed/false detections: ', num2str(WRONG(i))]);
    j=j+1;
end

