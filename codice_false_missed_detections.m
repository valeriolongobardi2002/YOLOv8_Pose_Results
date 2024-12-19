clc;
clear;
close all;


%versions = {'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_MEDIUM', ...
%            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL', ...
%            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_NANO'};
versions = {'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_MEDIUM', ...
            'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL', ...
            'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_NANO'};

%Variabile per errore su un keypoint specifico
ERR_x = zeros(3, 3680);
ERR_y = zeros(3,3680);
MISSED = zeros(3, 1);
FALSE = zeros(3, 1);
percentuale_total = zeros(3,1);

for v = 1:length(versions)
    
    [~, ~, ~, missed_detection, false_detection] = function_estrazione_dati(versions{v}, ...
        'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize');
        %'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize');     
    MISSED(v) = sum(missed_detection);
    FALSE(v) = sum(false_detection);
    percentuale_total(v) = 100*(MISSED(v)+FALSE(v))/(33*3680);
end


figure;
categories = categorical({'YOLOv8 MEDIUM', 'YOLOv8 SMALL', 'YOLOv8 NANO'});
categories = reordercats(categories, {'YOLOv8 MEDIUM', 'YOLOv8 SMALL', 'YOLOv8 NANO'});
bar(categories, [MISSED(1) FALSE(1); MISSED(2) FALSE(2); MISSED(3) FALSE(3)]);
title('Total detections: 33 x 3680');
legend('MISSED DETECTIONS', 'FALSE DETECTION');
text(0.3, 1100, ['Total missed and false det. MEDIUM: ' num2str(percentuale_total(1)) '%'], "Fontsize", 9);
text(0.3, 1000, ['Total missed and false det. SMALL: ' num2str(percentuale_total(2)) '%'], "Fontsize", 9);
text(0.3, 900, ['Total missed and false det. NANO: ' num2str(percentuale_total(3)) '%'], "Fontsize", 9);