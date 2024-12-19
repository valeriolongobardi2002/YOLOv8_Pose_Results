function visualizza_immagini(directorypath_images, folderPath_predictions, folderPath_true)

[~, keypoints_PRED, keypoints_TRUE, missed_det, false_det] = function_estrazione_dati(folderPath_predictions, folderPath_true);
imageFiels = dir(fullfile(directorypath_images,'*png'));

for i=1:100
    img=imread(fullfile(directorypath_images, imageFiels(i).name));
    positions_pred = keypoints_PRED(i,:);
    positions_true = keypoints_TRUE(i,:);
    k=0;
    for n=1:(33 - (missed_det(i)+false_det(i)))
        %img = insertShape(img,'filled-circle', [positions_pred(n+k)*640, positions_pred(n+k+1)*640, 5], 'Color','blue');
        
        img = insertShape(img,'filled-circle', [positions_true(n+k)*640, positions_true(n+k+1)*640, 5], 'Color','green');
        if n == 21 || n == 2
        img = insertText(img,[positions_true(n+k)*640, positions_true(n+k+1)*640], n ,"FontSize",20,"TextColor",'white');
        end
        %img = insertText(img,[positions_pred(n+k)*640, positions_pred(n+k+1)*640], n ,"FontSize",20,"TextColor",'white');
        k=k+1;
    end
    
    imshow(img);
    %title(['image', num2str(i),'di',num2str(length(imageFiels)), ...
   %      ' [',num2str(missed_det(i)),' missed det]', ...
    %     ' [',num2str(false_det(i)),' false det]']);
    pause(0.05);
end
close;
end