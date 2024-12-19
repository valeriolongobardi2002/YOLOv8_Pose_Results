clc;
clear;
close all;

versions = {'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL_NO_FLAG', ...
            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL'};
%versions = {'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL_NO_FLAG', ...
%            'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\output_testing_SMALL'};

directorypath_images = "C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Testing_dataset_2_seq_1_resize";

% Preallocazione delle variabili
media_x = zeros(3680, length(versions));
media_y = zeros(3680, length(versions));

% Simulazione dei dati
for v = 1:length(versions)
    %estrazione dei dati
    [confidence, keypoints_pred, keypoints_true, missed_detection, false_detection] = function_estrazione_dati(versions{v}, ...
        "C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize");
% 'C:\Users\valer\OneDrive\Desktop\TESI\Materiale Kaggle\RISULTATI TESTING\Labels_KRN_seq_1_resize'
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

% Definire la finestra mobile
window_size = 50;  % Numero di frame da visualizzare

% Creazione delle figure per l'animazione
figure;

subplot(3, 2, 1);
h1_r = plot(1, media_x(1, 1), '-r', 'MarkerSize', 6); 
hold on;
h1_b = plot(1, media_y(1, 1), '-b', 'MarkerSize', 6); 
title('YOLOv8 SMALL no flag');
xlabel('Frame');
ylabel('Mean error');
legend('X-axis error', 'Y-axis error');
hold off;

subplot(3, 2, 3);
h2_r = plot(1, media_x(1, 2), '-r', 'MarkerSize', 6); 
hold on;
h2_b = plot(1, media_y(1, 2), '-b', 'MarkerSize', 6); 
title('YOLOv8 SMALL');
xlabel('Frame');
ylabel('Mean error');
legend('X-axis error', 'Y-axis error');
hold off;


subplot(3, 2, 4);
h1x_m = plot(1, media_x(1, 1), '-k', 'MarkerSize', 6); 
hold on;
h2x_b = plot(1, media_x(1, 2), '-b', 'MarkerSize', 6);  
hold on;
title('Comparative analysis on x-axis');
xlabel('Frame');
ylabel('Mean error');
legend('YOLOv8 SMALL no flag', 'YOLOv8 SMALL');
hold off;

subplot(3, 2, 6);
h1y_m = plot(1, media_y(1, 1), '-k', 'MarkerSize', 6); 
hold on;
h2y_b = plot(1, media_y(1, 2), '-b', 'MarkerSize', 6);  
hold on;
title('Comparative analysis on y-axis');
xlabel('Frame');
ylabel('Mean error');
legend('YOLOv8 SMALL no flag', 'YOLOv8 SMALL');
hold off;
% Animazione
imageFiels = dir(fullfile(directorypath_images,'*png'));

for k = 1:3680
    % Calcola i limiti della finestra mobile
    x_min = max(1, k - window_size + 1);
    x_max = k;

    % Aggiorna i dati del grafico per YOLOv8_SMALL no flag
    set(h1_r, 'XData', x_min:x_max, 'YData', media_x(x_min:k, 1));
    set(h1_b, 'XData', x_min:x_max, 'YData', media_y(x_min:k, 1));
    
    % Aggiorna i dati del grafico per YOLOv8_SMALL
    set(h2_r, 'XData', x_min:x_max, 'YData', media_x(x_min:k, 2));
    set(h2_b, 'XData', x_min:x_max, 'YData', media_y(x_min:k, 2));

    
    %aggiorna confronto su x
    set(h1x_m, 'XData', x_min:x_max, 'YData', media_x(x_min:k, 1));
    set(h2x_b, 'XData', x_min:x_max, 'YData', media_x(x_min:k, 2));
    
    
    %aggiorna confronto su y
    set(h1y_m, 'XData', x_min:x_max, 'YData', media_y(x_min:k, 1));
    set(h2y_b, 'XData', x_min:x_max, 'YData', media_y(x_min:k, 2));
    

    % Ricalcola e aggiorna i limiti degli assi
    ymin = min([media_x(x_min:k, :); media_y(x_min:k, :)], [], 'all');
    ymax = max([media_x(x_min:k, :); media_y(x_min:k, :)], [], 'all');
    
    % Aggiorna i limiti degli assi Y e X per ogni subplot
    ylim(subplot(3, 2, 1), [ymin ymax+5]);
    ylim(subplot(3, 2, 3), [ymin ymax+5]);
    ylim(subplot(3, 2, 4), [ymin ymax+5]);
    ylim(subplot(3, 2, 6), [ymin ymax+5]);

    % Assicurarsi che x_min e x_max siano diversi
    if x_min < x_max
        xlim(subplot(3, 2, 1), [x_min x_max]);
        xlim(subplot(3, 2, 3), [x_min x_max]);
        xlim(subplot(3, 2, 4), [x_min x_max]);
        xlim(subplot(3, 2, 6), [x_min x_max]);
    end
    
    % Aggiorna il grafico
    drawnow;
    
    % Pausa per creare l'effetto di animazione
    pause(0.01);
    
    % Immagine satellite
    subplot(3,2,2)
    img = imread(fullfile(directorypath_images, imageFiels(k).name)); 
    imshow(img);
    pause(0.01);
end
