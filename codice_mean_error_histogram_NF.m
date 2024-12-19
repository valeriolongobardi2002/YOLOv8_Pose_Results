clc;
clear;
close all;

% Dati di esempio
%versions = {'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL', ...
%            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL_NO_FLAG'};
versions = {"C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL", ...
            "C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL_NO_FLAG"};

% Preallocazione delle variabili
media_x = zeros(3680, length(versions));
media_y = zeros(3680, length(versions));

% Simulazione dei dati
for v = 1:length(versions)
    % Simula l'estrazione dei dati
    [confidence, keypoints_pred, keypoints_true, missed_detection, false_detection] = function_estrazione_dati(versions{v}, ...
        "C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize");

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
        coordinate_x = coordinate_x(k, 1:end-2*(missed_detection(k)+false_detection(k)));
        coordinate_x_true = coordinate_x_true(k, 1:end-2*(missed_detection(k)+false_detection(k)));
        coordinate_y = coordinate_y(k, 1:end-2*(missed_detection(k)+false_detection(k)));
        coordinate_y_true = coordinate_y_true(k, 1:end-2*(missed_detection(k)+false_detection(k)));
            
        errore_x = abs(coordinate_x(:) * 640 - coordinate_x_true(:) * 640);
        errore_y = abs(coordinate_y(:) * 640 - coordinate_y_true(:) * 640);

        %Delete Outside FOV
        errore_x = nonzeros(errore_x);
        errore_y = nonzeros(errore_y);
        
        media_x(k, v) = mean(errore_x);
        media_y(k, v) = mean(errore_y);
    end
end

%Calcolo medie su tutte le immagini per ogni versione
mediaX=zeros(2,1);
mediaX(1)=mean(media_x(:,1));
mediaX(2)=mean(media_x(:,2));


mediaY=zeros(2,1);
mediaY(1)=mean(media_y(:,1));
mediaY(2)=mean(media_y(:,2));


%PLOT ISTOGRAMMI
figure;
subplot(2 ,2 ,1);
histogram(media_x(:,1), 'BinWidth', 1, 'FaceColor','r');
title('YOLOv8 SMALL');
xlabel('X-axis mean error (pix)');
ylabel('Number of occurances');
subtitle(['Mean = ' num2str(mediaX(1)) ' Standard deviation = ' num2str(std(media_x(:,1)))]);

subplot(2, 2, 3);
histogram(media_x(:,2), 'BinWidth', 1, 'FaceColor','r');
title('YOLOv8 SMALL no flag');
xlabel('X-axis mean error (pix)');
ylabel('Number of occurances');
subtitle(['Mean = ' num2str(mediaX(2)) ' Standard deviation = ' num2str(std(media_x(:,2)))]);

subplot(2 ,2 ,2);
histogram(media_y(:,1), 'BinWidth', 1, 'FaceColor','b');
title('YOLOv8 SMALL');
xlabel('Y-axis mean error (pix)');
ylabel('Number of occurances');
subtitle(['Mean = ' num2str(mediaY(1)) ' Standard deviation = ' num2str(std(media_y(:,1)))]);

subplot(2, 2, 4);
histogram(media_y(:,2), 'BinWidth', 1, 'FaceColor','b');
title('YOLOv8 SMALL no flag');
xlabel('Y-axis mean error (pix)');
ylabel('Number of occurances');
subtitle(['Mean = ' num2str(mediaY(2)) ' Standard deviation = ' num2str(std(media_y(:,2)))]);