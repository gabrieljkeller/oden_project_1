%{
2-Dimensional diffusion solver
(gabriel's adaptation)

Inputs:
    - N0: Initial cell count (cells)
    - D: Diffusivity parameter (mm^2/day) * just one value for now
    - h: spatial step (mm)
    - dt: time step (day)
    - t: time to stop simulation (day)
    - k: proliferation rate (1/day)

Outputs:
    - N: Cell count at time t
%}

function N = Diffusion_2D(N0, D, h, dt, t, k)
    theta = 707000;
    %Calculate number of steps to run
    nt = t/dt;  
    
    %How many voxels are in the cell map
    nvox = numel(N0); %not needed?
    nrows = size(N0,2);
    ncols = size(N0,1);
    
    %Setup simulation storage variable
    %now is a 3d matrix (rows, cols, time stepsw)
    Sim = zeros(nrows, ncols, nt+1);
    Sim(:,:,1) = N0;
    %Loop through time
    for i = 1:nt
        %Loop through all voxels in 2d space (j rows, k cols)
        for j = 1:nrows
            for k = 1:ncols
                % calculate d2N_x
                if(k==1) %We're at the left col. k-1 doesn't exist, use forward
                    d2N_x = (Sim(j,k,i) - 2*Sim(j,k+1,i) + Sim(j,k+2,i));
                elseif(k==ncols) %We're at the right col. k+1 doesn't exist, use backward
                    d2N_x = (Sim(j,k-2,i) - 2*Sim(j,k-1,i) + Sim(j,k,i));
                else %All other cases, use central
                    d2N_x = (Sim(j,k+1,i) - 2*Sim(j,k,i) + Sim(j,k-1,i));
                end


                % calculate d2N_y
                if(j==1) %We're at the top row. j-1 doesn't exist, use forward
                    d2N_y = (Sim(j,k,i) - 2*Sim(j+1,k,i) + Sim(j+2,k,i)); 
                elseif(j==nrows) %We're at the bottom row. j+1 doesn't exist, use backward
                    d2N_y = (Sim(j-2,k,i) - 2*Sim(j-1,k,i) + Sim(j,k,i));
                else %All other cases, use central
                    d2N_y = (Sim(j+1,k,i) - 2*Sim(j,k,i) + Sim(j-1,k,i));
                end

                d2N_x = D * d2N_x / (h^2);
                d2N_y = D * d2N_y / (h^2); %spatial step is same for x and y

                d2N = d2N_x + d2N_y;
                
                % proliferation: kN(x,y,t)(1-(N(x,y,t)/theta))
                %proliferation = (k * Sim(j, k, i)) * (1 - (Sim(j, k, i) / theta));
                %proliferation = 0;
             
                Sim(j, k, i+1) = Sim(j, k, i) + dt * (d2N + proliferation); 
            end
        end
    end
    %End of loop, save last point in Sim
    N = Sim(:,:,end);
end