
function [ Rsq] = imageTrialRsq( allTrialCounts )
%IMAGESELECTIVITYINDEX Calculates the selectivity to natural images
%   First defined in Quian Quiroga et al. (2007), also used by the Allen
%   Institue Brain Observatory.
%   Inputs:
%           allTrialCounts: n x Nt x p matrix, n is number of cells, Nt is number of trials
%   and p number of images
%   Outputs:
%           sIndex: n x 1 vector

cellN=size(allTrialCounts,1);
nall=size(allTrialCounts,3);

oddMean=reshape(mean(allTrialCounts(:,1:2:end,:),2), [cellN nall]);
evenMean=reshape(mean(allTrialCounts(:,2:2:end,:),2), [cellN nall]);

Rsq=1-sum((oddMean-evenMean).^2,2)./sum((oddMean-repmat(mean(oddMean,2),[1 nall])).^2,2);
Rsq=Rsq.*(Rsq>0);

Rsq2=1-sum((oddMean-evenMean).^2,2)./sum((evenMean-repmat(mean(evenMean,2),[1 nall])).^2,2);
Rsq2=Rsq2.*(Rsq2>0);

Rsq=mean([Rsq Rsq2],2);

end
