function outliers = HRV_denoise1(s, method, opt1, opt2)
%locateOutliers: locates artifacts/outliers from data series
% FOR OUR USE 'PERCENT':PERCENTLIMIT=0.2
%  Inputs:  s = array containg data series
%           method = artifact removal method to use.
%  methods: 'percent' = percentage filter: locates data > x percent diff than previous data point.               
%           'above' = Threshold filter: locates data > threshold value
%           'below' = Threshold filter: locates data < threshold value
%Outputs:   outliers = logical array of whether s is artifact/outlier or not
%                       eg. - [0 0 0 1 0], 1=artifact, 0=normal
%                       
%Examples:
%   Locate outliers with 20% percentage filter:
%       outliers = locateOutlers(s,'percent',0.2)
%   Locate outliers that are above a threshold of 0.5:
%       outliers = locateOutlers(s,'thresh','above',0.5)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin < 2
       error('Not enough input arguments')
       return;
    end
    [m,n]=size(s);    
    if ((m>n)&&(n>1)) || ((n>m)&&(m>1))
        error('Input array must be 1-dim')
        return;
    end
    if m<n
        s=s';
    end
    
        switch lower(method)
        case 'percent' %percentage filter
            outliers = percentFilter(s,opt1);
        case 'thresh' %threshold filter
            outliers = threshFilter(s,opt1,opt2);
        otherwise
            outliers=false(length(s),1);
        end
        outliers=logical(outliers); %convert to logical array
        
          function [outliers]=percentFilter(s,perLimit)
        
        if perLimit>1 
            perLimit=perLimit/100; %assume incorrect input and correct it.
        end
        outliers=false(length(s),1); %preallocate
        pChange=abs(diff(s))./s(1:end-1); %percent chage from previous
        %find index of values where pChange > perLimit
        outliers(2:end) = (pChange >perLimit);
          end
      
      function [outliers]=threshFilter(s,type,thresh)
    %threshFilter: Locate outliers based on a threshold

        n = length(s);
        % Create a matrix of thresh values by replicating the thresh for n rows
        thresh = repmat(thresh,n,1);
        % Create a matrix of zeros and ones, where ones indicate the location of outliers
        if strcmp(type,'above')        
            outliers = s > thresh;
        elseif strcmp(type,'below')
            outliers = s < thresh;        
        end
    end
end