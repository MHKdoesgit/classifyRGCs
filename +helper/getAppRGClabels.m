

function [lbtomatch, rgclabelnum] = getAppRGClabels(lbindex)

switch lower(lbindex)
    
    case {1, '1', 'off parasol', 'off p'}
        lbtomatch = 'off parasol';
        rgclabelnum = 1;
        
    case {2, '2', 'on parasol', 'on p'}
        lbtomatch = 'on parasol';
        rgclabelnum = 2;
        
    case {3, '3', 'off midget', 'off m'}
        lbtomatch = 'off midget';
        rgclabelnum = 3;
        
    case {4, '4', 'on midget', 'on m'}
        lbtomatch = 'on midget';
        rgclabelnum = 4;
        
    case {5, '5', 'off smooth', 'off s'}
        lbtomatch = 'off smooth';
        rgclabelnum = 5;
        
    case {6, '6', 'on smooth', 'on s'}
        lbtomatch = 'on smooth';
        rgclabelnum = 6;
        
    case {7, '7', 'ds', 'd'}
        lbtomatch = 'DS';
        rgclabelnum = 7;
        
    case {8, '8', 'os', 'o'}
        lbtomatch = 'OS';
        rgclabelnum = 8;
        
    case {9, '9', 'bistratified', 'bist'}
        lbtomatch = 'bistratified';
        rgclabelnum = 9;
        
    case {10, 'b', 'bigspike', 'bigspk'}
        lbtomatch = 'big spike';
        rgclabelnum = 10;
end


end