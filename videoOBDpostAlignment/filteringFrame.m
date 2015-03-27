function a=filteringFrame(varargin)
% filteringFrame(image,filter type,matrix size)
% filter type 'gaussian', 'sobel', 'prewitt', 'laplacian', 'log', 'average', 'unsharp', 'disk', 'motion'
if nargin==3
    h=fspecial(varargin{2},varargin{3}); 
    a = imfilter(varargin{1},h);
else disp('Please input filteringFrame(image,filter type,matrix size)');
     a=[];
end
