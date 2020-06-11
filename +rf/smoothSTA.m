function [smoothstamat] = smoothSTA(stamat, sigma)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Nt = size(stamat,3);
smoothstamat = zeros(size(stamat), 'single');
for it = 1 : Nt
    smoothstamat(:,:,it) = imgaussfilt(stamat(:,:,it),sigma,...
        'FilterSize', 4*ceil(2*sigma)+1);
end

end

