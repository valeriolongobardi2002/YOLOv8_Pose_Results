function visualizza_immagini_confronto_NSM(directorypath_images, folderPath_true, folderPath_predictions_NANO, ...
    folderPath_predictions_SMALL, folderPath_predictions_MEDIUM )

[~, keypoints_PRED_N, ~, missed_det_N, false_det_N] = function_estrazione_dati(folderPath_predictions_NANO, folderPath_true);
[~, keypoints_PRED_S, ~, missed_det_S, false_det_S] = function_estrazione_dati(folderPath_predictions_SMALL, folderPath_true);
[~, keypoints_PRED_M, keypoints_TRUE, missed_det_M, false_det_M] = function_estrazione_dati(folderPath_predictions_MEDIUM, folderPath_true);
imageFiels = dir(fullfile(directorypath_images,'*png'));
for i=1:length(imageFiels)
    img=imread(fullfile(directorypath_images, imageFiels(i).name));
    positions_pred_N = keypoints_PRED_N(i,:);
    positions_pred_S = keypoints_PRED_S(i,:);
    positions_pred_M = keypoints_PRED_M(i,:);
    positions_true = keypoints_TRUE(i,:);
    k=0;
    for n=1:(33 - (missed_det_N(i)+false_det_N(i)))
        img = insertShape(img,'filled-circle', [positions_pred_N(n+k)*640, positions_pred_N(n+k+1)*640, 5], 'Color','blue');
        img = insertShape(img,'filled-circle', [positions_true(n+k)*640, positions_true(n+k+1)*640, 5], 'Color','green');
        img = insertText(img,[positions_true(n+k)*640, positions_true(n+k+1)*640], n ,"FontSize",20,"TextColor",'white');
        %img = insertText(img,[positions_pred(n+k)*640, positions_pred(n+k+1)*640], n ,"FontSize",20,"TextColor",'white');
        k=k+1;
    end
    k=0;
    for n=1:(33 - (missed_det_S(i)+false_det_S(i)))
        img = insertShape(img,'filled-circle', [positions_pred_S(n+k)*640, positions_pred_S(n+k+1)*640, 5], 'Color','red');
         k=k+1;
    end
    k=0;
    for n=1:(33 - (missed_det_M(i)+false_det_M(i))) 
        img = insertShape(img,'filled-circle', [positions_pred_M(n+k)*640, positions_pred_M(n+k+1)*640, 5], 'Color','magenta');
        k=k+1;
    end
    imshow(img);
    title(['image', num2str(i),' [ Missed det: ', num2str(missed_det_N(i)),' Nano ', ...
        num2str(missed_det_S(i)),' Small ', ...
        num2str(missed_det_M(i)),' Medium]', ...
        ' [ False det: ', num2str(false_det_N(i)),' Nano ', ...
        num2str(false_det_S(i)),' Small ', ...
        num2str(false_det_M(i)),' Medium]']);
    
    pause(0.05);
end
close;
end