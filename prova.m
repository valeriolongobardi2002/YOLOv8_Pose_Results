%agg func estrazione dati
%grafici NSM cambia solo nome
%grafici S_NSF
%% prova codice mean error live con immagine del satellite;
clc;
clear;
close all;

% Dati di esempio
versions = {'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_MEDIUM', ...
            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_SMALL', ...
            'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_NANO'};

directorypath_images = "C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Testing_dataset_2_seq_1_resize";

% Preallocazione delle variabili
media_x = zeros(3680, length(versions));
media_y = zeros(3680, length(versions));

% Simulazione dei dati
for v = 1:length(versions)
    % Simula l'estrazione dei dati
    [confidence, keypoints_pred, keypoints_true, missed_detection, false_detection] = function_estrazione_dati(versions{v}, ...
        'C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize');
        %"C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize");

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
        media_x(k, v) = mean(errore_x);
        media_y(k, v) = mean(errore_y);
    end
end
figure;
plot(1:3680, media_x(:, 1), '-r', 'MarkerSize', 6); % Prima serie di dati
hold on; % Mantiene il grafico corrente per aggiungere altre serie di dati
plot(1:3680, media_x(:, 2), '-b', 'MarkerSize', 6); % Seconda serie di dati
hold on;
plot(1:3680, media_x(:, 3), '-g', 'MarkerSize', 6); % Terza serie di dati
title('Mean error on x');
xlabel('Frame');
ylabel('Mean error');
legend('Medium', 'Small','Nano');
hold off; % Rilascia il grafico corrente


figure;
plot(1:3680, media_y(:, 1), '-r', 'MarkerSize', 6); % Prima serie di dati
hold on; % Mantiene il grafico corrente per aggiungere altre serie di dati
plot(1:3680, media_y(:, 2), '-b', 'MarkerSize', 6); % Seconda serie di dati
hold on;
plot(1:3680, media_y(:, 3), '-g', 'MarkerSize', 6); % Terza serie di dati
title('Mean error on y');
xlabel('Frame');
ylabel('Mean error');
legend('Medium', 'Small','Nano');
hold off; % Rilascia il grafico corrente
%%
% Definire la finestra mobile
window_size = 500;  % Numero di frame da visualizzare

% Creazione delle figure per l'animazione
figure;

subplot(3, 2, 1);
h1_r = plot(1, media_x(1, 1), '-r', 'MarkerSize', 6); 
hold on;
h1_b = plot(1, media_y(1, 1), '-b', 'MarkerSize', 6); 
title('YOLOv8 MEDIUM');
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

subplot(3, 2, 5);
h3_r = plot(1, media_x(1, 3), '-r', 'MarkerSize', 6); 
hold on;
h3_b = plot(1, media_y(1, 3), '-b', 'MarkerSize', 6); 
title('YOLOv8 NANO');
xlabel('Frame');
ylabel('Mean error');
legend('X-axis error', 'Y-axis error');
hold off;

% Animazione
imageFiels = dir(fullfile(directorypath_images,'*png'));
%%
for k = 1:3680
    % Calcola i limiti della finestra mobile
    x_min = max(1, k - window_size + 1);
    x_max = k;

    % Aggiorna i dati del grafico per YOLOv8_MEDIUM
    set(h1_r, 'XData', x_min:x_max, 'YData', media_x(x_min:k, 1));
    set(h1_b, 'XData', x_min:x_max, 'YData', media_y(x_min:k, 1));
    
    % Aggiorna i dati del grafico per YOLOv8_SMALL
    set(h2_r, 'XData', x_min:x_max, 'YData', media_x(x_min:k, 2));
    set(h2_b, 'XData', x_min:x_max, 'YData', media_y(x_min:k, 2));

    % Aggiorna i dati del grafico per YOLOv8_NANO
    set(h3_r, 'XData', x_min:x_max, 'YData', media_x(x_min:k, 3));
    set(h3_b, 'XData', x_min:x_max, 'YData', media_y(x_min:k, 3));
    
    % Ricalcola e aggiorna i limiti degli assi
    ymin = min([media_x(x_min:k, :); media_y(x_min:k, :)], [], 'all');
    ymax = max([media_x(x_min:k, :); media_y(x_min:k, :)], [], 'all');
    
    % Aggiorna i limiti degli assi Y e X per ogni subplot
    ylim(subplot(3, 2, 1), [ymin ymax]);
    ylim(subplot(3, 2, 3), [ymin ymax]);
    ylim(subplot(3, 2, 5), [ymin ymax]);

    % Assicurarsi che x_min e x_max siano diversi
    if x_min < x_max
        xlim(subplot(3, 2, 1), [x_min x_max]);
        xlim(subplot(3, 2, 3), [x_min x_max]);
        xlim(subplot(3, 2, 5), [x_min x_max]);
    end
    
    % Aggiorna il grafico
    drawnow;
    
    % Pausa per creare l'effetto di animazione
    pause(0.01);
    
    % Immagine satellite
    subplot(3,2,4)
    img = imread(fullfile(directorypath_images, imageFiels(k).name)); 
    imshow(img);
    pause(0.01);
end
%% prova del confronto sulle immagini Small e no flag;
clc;
clear;
close all;

visualizza_immagini('C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Testing_dataset_2_seq_1_resize', ...
  "C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\output_testing_NANO", ...
   "C:\Users\HP\OneDrive\Desktop\TESI UNI\testing\Labels_KRN_seq_1_resize")


