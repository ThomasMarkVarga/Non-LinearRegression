clear all
close all
clc
load("iddata-09.mat")
figure;
subplot(121); plot(id); title('Identification');
subplot(122); plot(val); title('Validation');

% date identificare
uid = id.u;
yid = id.y;

% date validare
uval = val.u;
yval = val.y;

% numarul de elemente 
N = length(yid);

% tunable variables
na = 2;
nb = 2;
nk = 1;

% polynomial power
m = 3; 

% citire t si calculare Sampling time
t = id.SamplingInstants;
Ts = t(2) - t(1);

% generare combinari puteri
No = na + nb + 1;

count = 1;
for i = 0:(No+1)^No-1
    indices = convertToBase(i, No+1, No);
    resultMatrix(count, :) = indices;
    count = count + 1;
end

% sortare combinari puteri bune
j = 1;
for i = 1:length(resultMatrix)
    if(sum(resultMatrix(i,:)) == m)
        finalComb(j,:) = resultMatrix(i,:);
        j = j + 1;
    end
end

% identification 
phi_id = generatePhi(N, yid, uid, na ,nb, finalComb);
teta = phi_id \ yid;

% prediction
phi_val = generatePhi(N, yval, uval, na , nb, finalComb);
yhat = phi_val * teta;

% simulation
phi_sim = generatePhi(N, yhat, uval, na , nb, finalComb);
yhat_sim = phi_sim * teta;

% MSE calc
MSE_pred = 0;
MSE_sim = 0;
MSE_pred = 1/N * sum((yval - yhat).^2);
MSE_sim = 1/N * sum((yval - yhat_sim).^2);

% figures for pred and sim
figure; plot(t,yhat,t,yval)
legend('yhat','yval');
textPred = ['Prediction MSE = ', num2str(MSE_pred)];
title(textPred);

figure; plot(t, yhat, t, yhat_sim);
legend('yhat','yhat-sim')
textSim = ['Simulation MSE = ', num2str(MSE_sim)];
title(textSim);

%% convertToBase function
function result = convertToBase(index, base,numDigits)
    result = zeros(1, numDigits);
    for i = numDigits:-1:1
        result(numDigits - i + 1) = floor(index / base^(i-1));
        index = mod(index, base^(i-1));
    end
end

%% generatePhi function
function phi = generatePhi(N, y, u, na, nb, puteri)
    % N - number of elements in y/u
    % y - output
    % u - input
    
    phi = zeros(N, length(puteri));
    startPos = na + 1;
    for k = startPos : N                % parcurgerea tuturor elementelor
        for i = 1 : length(puteri)     % parcurgerea fiecarui element de pe linie de asemenea selectarea liniei din matricea de puteri
            
            prod = 1;
            for j = 2 : na + 1     % parcurgerea prin puterile de pe fiecare linie
                prod = prod * (y(k - j + 1)^puteri(i, j));
            end
            for j = na + 2 : na + nb + 1
                prod = prod * (u(k - j + na + 1)^puteri(i, j));
            end

            phi(k, i) = prod;
        end
    end
    
end