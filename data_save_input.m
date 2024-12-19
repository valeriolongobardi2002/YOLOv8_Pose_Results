clc;
close all;
clear;


%versions = {'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL', ...
%            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL_NO_FLAG'};
versions = {'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL', ...
            'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL_NO_FLAG'};


[~, keypoints_pred, keypoints_true, missed_detection, false_detection] = function_estrazione_dati_singolo_key(versions{1}, ...
        'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize');

save('data_input_nostro', 'keypoints_true', "keypoints_pred", "false_detection", "missed_detection");
