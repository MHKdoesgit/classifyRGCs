
function [ output ] = moransI( A, Nx, Ny )
%MoransI Computes Moran's I value
%   uses only nearest neighbors
    thismean = mean(mean(A));
    sum1 = 0;
    sum2 = 0;
    sum3 = 0;
    for x=1:Nx
        for y=1:Ny
            if x>1
                sum1 = sum1 + (A(x,y)-thismean)*(A(x-1,y)-thismean);
                sum2 = sum2 + 1;
            end
            if x<Nx
                sum1 = sum1 + (A(x,y)-thismean)*(A(x+1,y)-thismean);
                sum2 = sum2 + 1;
            end
            if y>1
                sum1 = sum1 + (A(x,y)-thismean)*(A(x,y-1)-thismean);
                sum2 = sum2 + 1;
            end
            if y<Ny
                sum1 = sum1 + (A(x,y)-thismean)*(A(x,y+1)-thismean);
                sum2 = sum2 + 1;
            end
            sum3 = sum3 + ( A(x,y) - thismean )*( A(x,y) - thismean );
        end
    end
    output = Nx*Ny*sum1/sum2/sum3;
end

