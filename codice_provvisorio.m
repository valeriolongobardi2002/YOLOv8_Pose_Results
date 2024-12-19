%Codice per eliminare false detection e distinguerle da i keypoints fuori
%FOV
%Calcolare quante false ci sono in ogni immagine a seconda della versione


%visualizza_immagini('C:\Users\valer\OneDrive\Desktop\STESURA TESI\Testing_dataset_2_seq_1_resize', 'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_MEDIUM', "C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize");
%visualizza_immagini("C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Testing_dataset_2_seq_1_resize", ...
%"C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL", ...
%"C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize")

%visualizza_immagini_confronto_NSM('C:\Users\valer\OneDrive\Desktop\STESURA TESI\Testing_dataset_2_seq_1_resize', "C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize", 'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_NANO','C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL', 'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_MEDIUM')

clc;
close all; 
clear;
function_estrazione_dati('C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_MEDIUM',"C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize");
