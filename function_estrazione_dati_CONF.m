function [CONFIDENCE, keypoints_PRED, keypoints_TRUE, missed_detection, false_detection,  out_of_conf] = function_estrazione_dati_CONF(folderPath_predictions, folderPath_true, conf_treshold)


images = dir(fullfile(folderPath_predictions, '*.txt'));
labels = dir(fullfile(folderPath_true, '*.txt'));

keypoints_PRED = zeros(3680, 66);
keypoints_TRUE = zeros(3680, 66);
CONFIDENCE = zeros(3680, 33);
out_of_conf=zeros(length(images),1);
missed_detection=zeros(length(images),1);
false_detection=zeros(length(images),1);

for k = 1:length(images)
    image = fullfile(folderPath_predictions, images(k).name);
    label = fullfile(folderPath_true, labels(k).name);
    keypoints_predictions = load(image);
    keypoints_true = load(label);

    i = 5;
    j = 0;
    confidence = zeros(33,1);
    
    if length(keypoints_predictions) > 72
        while j < length(keypoints_predictions)
            j = i + 3;
            if j > length(keypoints_predictions) % Check if j exceeds the length of T
                break;
            end  
            confidence(j) = keypoints_predictions(j);
            keypoints_predictions(j) = [];
            keypoints_true(j) = [];
            j = j-1;
            i = j;
        end
        CONFIDENCE(k,:) = nonzeros(confidence)';
    else
        while j < length(keypoints_predictions)
            j = i + 3;
            if j > length(keypoints_predictions) % Check if j exceeds the length of T
                break;
            end
            keypoints_true(j) = [];
            j = j-1;
            i = j;
        end
    end

    keypoints_PRED(k,:) = keypoints_predictions(6:end);
    keypoints_TRUE(k,:) = keypoints_true(6:71);
    
    %% ELIMINAZIONE OUTLIER
    h=1;
    p=1;
    %CONFIDANCE 
    while h <= (length(CONFIDENCE(k,:))-1)

            if  CONFIDENCE(k,h) <= conf_treshold
                key_true = keypoints_TRUE(k,:);
                key_pred = keypoints_PRED(k,:);
                key_true(p:p+1)=[];
                key_pred(p:p+1)=[];
                key_true = [key_true 0 0];
                key_pred = [key_pred 0 0];
                keypoints_TRUE(k,:) = key_true;
                keypoints_PRED(k,:) = key_pred;
                p=p-2;
                out_of_conf(k) = out_of_conf(k)+1;
            end
            h=h+1;
            p=p+2;

    end
    q=1;

    %MISSED DETECTION
    while q <= (length(keypoints_PRED(k,:))-1)
        if keypoints_PRED(k,q)==0 && keypoints_PRED(k,q+1)==0
            done = false;
            if keypoints_TRUE(k,q)==0 && keypoints_TRUE(k,q+1)~=0
                key_true = keypoints_TRUE(k,:);
                key_pred = keypoints_PRED(k,:);
                key_true(q:q+1)=[];
                key_pred(q:q+1)=[];
                key_true = [key_true 0 0];
                key_pred = [key_pred 0 0];
                keypoints_TRUE(k,:) = key_true;
                keypoints_PRED(k,:) = key_pred;
                q = q-2;
                missed_detection(k) = missed_detection(k)+1;
                done = true;
            end
            if ~done && keypoints_TRUE(k,q)~=0 && keypoints_TRUE(k,q+1)==0
                key_true = keypoints_TRUE(k,:);
                key_pred = keypoints_PRED(k,:);
                key_true(q:q+1)=[];
                key_pred(q:q+1)=[];
                key_true = [key_true 0 0];
                key_pred = [key_pred 0 0];
                keypoints_TRUE(k,:) = key_true;
                keypoints_PRED(k,:) = key_pred;
                q=q-2;
                missed_detection(k) = missed_detection(k)+1;
                done = true;
            end
            if  ~done && keypoints_TRUE(k,q)~=0 && keypoints_TRUE(k,q+1)~=0
                key_true = keypoints_TRUE(k,:);
                key_pred = keypoints_PRED(k,:);
                key_true(q:q+1)=[];
                key_pred(q:q+1)=[];
                key_true = [key_true 0 0];
                key_pred = [key_pred 0 0];
                keypoints_TRUE(k,:) = key_true;
                keypoints_PRED(k,:) = key_pred;
                q=q-2;
                missed_detection(k) = missed_detection(k)+1;
            end
        end
        q=q+2;
    end

    %FALSE DETECTION
    r=1;
    while r <= (length(keypoints_PRED(k,:))-1)
        if keypoints_TRUE(k,r)==0 && keypoints_TRUE(k,r+1)==0
            done = false; 
            if  keypoints_PRED(k,r)==0 && keypoints_PRED(k,r+1)~=0
                key_true = keypoints_TRUE(k,:);
                key_pred = keypoints_PRED(k,:);
                key_true(r:r+1)=[];
                key_pred(r:r+1)=[];
                key_true = [key_true 0 0];
                key_pred = [key_pred 0 0];
                keypoints_TRUE(k,:) = key_true;
                keypoints_PRED(k,:) = key_pred;
                r = r-2;
                false_detection(k) = false_detection(k)+1;
                done = true;
            end
            if ~done && keypoints_PRED(k,r)~=0 && keypoints_PRED(k,r+1)==0
                key_true = keypoints_TRUE(k,:);
                key_pred = keypoints_PRED(k,:);
                key_true(r:r+1)=[];
                key_pred(r:r+1)=[];
                key_true = [key_true 0 0];
                key_pred = [key_pred 0 0];
                keypoints_TRUE(k,:) = key_true;
                keypoints_PRED(k,:) = key_pred;
                r = r-2;
                false_detection(k) = false_detection(k)+1;
                done = true;
            end
            if ~done && keypoints_PRED(k,r)~=0 && keypoints_PRED(k,r+1)~=0
                key_true = keypoints_TRUE(k,:);
                key_pred = keypoints_PRED(k,:);
                key_true(r:r+1)=[];
                key_pred(r:r+1)=[];
                key_true = [key_true 0 0];
                key_pred = [key_pred 0 0];
                keypoints_TRUE(k,:) = key_true;
                keypoints_PRED(k,:) = key_pred;
                r = r-2;
                false_detection(k) = false_detection(k)+1;
            end
        end
        r=r+2;
    end
end

end