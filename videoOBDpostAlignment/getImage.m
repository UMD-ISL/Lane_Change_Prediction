function imageMatrix=getImage(readerObj,frameNumber,position)
thisFrame=read(readerObj,frameNumber);
%         centalImage=rgb2hsv(centalImage);
%         centalImage=rgb2lab(centalImage);
image=imcrop(thisFrame,position);
image=filteringFrame(image,'average',3);
imageMatrix=im2double(image);