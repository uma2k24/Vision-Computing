% Q3.3.1

cv_cover = imread('..\data\cv_cover.jpg');

book_vid = loadVid('..\data\book.mov');
ar_source = loadVid('..\data\ar_source.mov');

frames = ar_source(1).cdata; % Acquire frames of the source film
for i=1:size(frames,1)
    if sum(frames(i,:)) > 10000
        cropInd = i;
        break
    end
end

vid_write = VideoWriter('..\results\ar.avi'); % Output file
open(vid_write);

%% Display the middle third of the source film by cropping the frames.
for i=1:length(ar_source)
    
   book_frame = book_vid(i).cdata;
   ar_frame = ar_source(i).cdata;
   crop_frame = ar_frame(cropInd:size(ar_frame,1)-cropInd, 213:426, :); % 640 = # columns in ar_frame -> 640/3 ~= 213.33 -> 213*2 = 426 -> 213:426
   if sum(sum(sum(crop_frame))) < 500000
      crop_frame(:) = 0; 
   end
   
   [locs1, locs2] = matchPics(cv_cover, book_frame);
   %[locs1, locs2] = matchPics_SURF(cv_cover, book_frame);
   [H,inliers] = computeH_ransac(locs1, locs2); % Use RANSAC similarly as Harry-Potterization
      
   scaled_ar = imresize(crop_frame, [size(cv_cover,1) size(cv_cover,2)]); % Resize to fit book cover
   
   composite_frame = compositeH(H, scaled_ar, book_frame);
      
   writeVideo(vid_write,composite_frame); % Write source video to the book video, frame by frame

end

%% Handle the remaining video since both sources are different lengths
remainder = length(book_vid) - length(ar_source);

for i=1:remainder
    
   book_frame = book_vid(i+length(ar_source)).cdata;
   ar_frame = ar_source(i).cdata;
   crop_frame = ar_frame(cropInd:size(ar_frame,1)-cropInd, 213:426, :);
   if sum(sum(sum(crop_frame))) < 500000
      crop_frame(:) = 0; 
   end
   
   [locs1, locs2] = matchPics(cv_cover, book_frame);
   %[locs1, locs2] = matchPics_SURF(cv_cover, book_frame);
   [H,inliers] = computeH_ransac(locs1, locs2);
      
   scaled_ar = imresize(crop_frame, [size(cv_cover,1) size(cv_cover,2)]);
   
   composite_frame = compositeH(H, scaled_ar, book_frame);
      
   writeVideo(vid_write,composite_frame);

end

close(vid_write); %close video writer