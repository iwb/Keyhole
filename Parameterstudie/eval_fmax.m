function fmax = eval_fmax(A)
% Funktion zur Berechnung der Grenzfrequenz für eine Dauerhafte Oszillation
% A: Soll-Amplitude auf dem Bauteil in mm
% fmax: Maximal-Frequenz in Hz

% Laden der Daten
load([pwd, '\data_fmax.mat']);
A = A(:);
fmax = zeros(length(A),1);
for i = 1 : length(A)
    if A(i,1) < min(Avec)
        fmax(i,1) = fvec(1);
    elseif A(i,1) >= min(Avec) && A(i,1) <= max(Avec)
        fmax(i,1)= interp1(Avec,fvec,A(i,1),'linear','extrap');
    else
        fmax(i,1) = fvec(length(fvec));
    end
end
