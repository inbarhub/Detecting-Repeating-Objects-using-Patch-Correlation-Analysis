function lapInFft = lap_fft(I)
eps = 10^-10;
lap = zeros(size(I));
lap(1,1) = -4;
lap(2,1) = 1;
lap(1,2) = 1;
lap(1,end) = 1;
lap(end,1) = 1;
lapInFft = fft2(lap);
end