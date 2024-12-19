function visualizza_immagini_confronto_S_SNF(directorypath_images, folderPath_true, ...
    folderPath_predictions_SMALL, folderPath_prediction_SMALL_NO_FLAG )

[~, keypoints_PRED_S, ~, missed_det_S, false_det_S] = function_estrazione_dati(folderPath_predictions_SMALL, folderPath_true);
[~, keypoints_PRED_S_NF, keypoints_TRUE, missed_det_S_NF, false_det_S_NF] = function_estrazione_dati(folderPath_prediction_SMALL_NO_FLAG, folderPath_true);
imageFiles = dir(fullfile(directorypath_images, '*png'));

for i = 1:length(imageFiles)
    img = imread(fullfile(directorypath_images, imageFiles(i).name));

    positions_pred_S = keypoints_PRED_S(i, :);
    positions_pred_S_NF = keypoints_PRED_S_NF(i, :);
    positions_true = keypoints_TRUE(i, :);

    % Loop to plot the true and predicted keypoints for SMALL
    for n = 1:(33 - (missed_det_S(i) + false_det_S(i)))
        % Plot predicted SMALL keypoints in blue
        img = insertShape(img, 'filled-circle', [positions_pred_S(2*n-1)*640, positions_pred_S(2*n)*640, 5], 'Color', 'blue');
        
        % Plot true keypoints in green with correct numbering
        img = insertShape(img, 'filled-circle', [positions_true(2*n-1)*640, positions_true(2*n)*640, 5], 'Color', 'green');
        img = insertText(img, [positions_true(2*n-1)*640, positions_true(2*n)*640], n, "FontSize", 20, "TextColor", 'white');
    end

    % Loop to plot the predicted keypoints for SMALL NO FLAG
    for n = 1:(33 - (missed_det_S_NF(i) + false_det_S_NF(i)))
        img = insertShape(img, 'filled-circle', [positions_pred_S_NF(2*n-1)*640, positions_pred_S_NF(2*n)*640, 5], 'Color', 'magenta');
    end
    
    % Display the image with title
    imshow(img);
    title(['image', num2str(i), ' [ Missed det: ', num2str(missed_det_S_NF(i)), ' Small no Fleg, ', ...
        num2str(missed_det_S(i)), ' Small ] ', ...
        ' [ False det: ', num2str(false_det_S_NF(i)), ' Small no Fleg, ', ...
        num2str(false_det_S(i)), ' Small ]']);
    
    pause(0.05);
end
close;
end