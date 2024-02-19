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

