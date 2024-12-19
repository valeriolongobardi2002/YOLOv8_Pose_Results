clc;
clear;
close all;


%versions = {'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_MEDIUM', ...
%            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL', ...
%            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_NANO'};
versions = {"C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_MEDIUM", ...
            'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL', ...
            'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_NANO'};


%ESTRAZIONE CONFIDENCE SCORES

CONFIDENCE = zeros(3, 3680); %Array di CONFIDENCE di un singolo KEYPOINT
numkey = 2;
conf_media = zeros(3, 3680);

for v = 1:length(versions)
    [confidence, ~, ~, ~, ~] = function_estrazione_dati(versions{v}, ...
        'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize');
        %'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize');
    CONFIDENCE(v,:)=confidence(:,numkey);
    for k=1:3680
        conf_media(v,k)=mean(confidence(k,:));
    end
end

%PLOT FISSATO UN KEYPOINT

figure;
plot(1:3680, CONFIDENCE(1,:), '-g');
hold on;
plot(1:3680, CONFIDENCE(2,:), '-y');
hold on;
plot(1:3680, CONFIDENCE(3,:), '-m');
hold off;
title(['Confidence scores on ' num2str(numkey) 'th keypoint']);
xlabel('Frame');
ylabel('Confidence score');
xlim([1 3680]);
ylim([0 2]);
legend('YOLOv8 MEDIUM', 'YOLOv8 SMALL', 'YOLOv8 NANO');


%PLOT DI CONFIDENCE MEDIA SULLE IMMAGINI
figure;
plot(1:3680, conf_media(1,:), '-g');
hold on;
plot(1:3680, conf_media(2,:), '-y');
hold on;
plot(1:3680, conf_media(3,:), '-m');
hold off;
title('Mean confidence scores');
xlabel('Frame');
ylabel('Mean confidence score');
xlim([1 3680]);
ylim([0 2]);
legend('YOLOv8 MEDIUM', 'YOLOv8 SMALL', 'YOLOv8 NANO');


%ISTOGRAMMI DI CONFIDENCE MEDIA
media=zeros(3,1);

media(1) = mean(conf_media(1,:));
media(2) = mean(conf_media(2,:));
media(3) = mean(conf_media(3,:));

figure;
subplot(3,1,1);
histogram(conf_media(1,:));
title('YOLOv8 MEDIUM');
xlabel('Mean confidence score');
ylabel('Number of occurances');
subtitle(['Mean = ' num2str(media(1)) ' Standard deviation = ' num2str(std(conf_media(1,:)))]);

subplot(3,1,2);
histogram(conf_media(2,:));
title('YOLOv8 SMALL');
xlabel('Mean confidence score');
ylabel('Number of occurances');
subtitle(['Mean = ' num2str(media(2)) ' Standard deviation = ' num2str(std(conf_media(2,:)))]);

subplot(3,1,3);
histogram(conf_media(1,:));
title('YOLOv8 NANO');
xlabel('Mean confidence score');
ylabel('Number of occurances');
subtitle(['Mean = ' num2str(media(3)) ' Standard deviation = ' num2str(std(conf_media(3,:)))]);


