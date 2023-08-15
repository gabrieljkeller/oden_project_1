%{
1-Dimensional diffusion solver

Inputs:
    - N0: Initial cell count (cells)
    - D: Diffusivity parameter (mm^2/day)
    - h: spatial step (mm)
    - dt: time step (day)
    - t: time to stop simulation (day)

Outputs:
    - N: Cell count at time t
%}

function N = Diffusion_1D(N0, D, h, dt, t)
    %Calculate number of steps to run
    nt = t/dt;  
    
    %How many voxels are in the cell map
    nvox = numel(N0);
    
    %Setup simulation storage variable
    Sim = zeros(nvox, nt+1);
    Sim(:,1) = N0;
    
    %Loop through time
    for j = 1:nt
        
        %Loop through space
        for i = 1:nvox
            
            %Check for boundary conditions as you loop
            if(i == 1) %The voxel at i-1 doesn't exist
                d2N = (2*Sim(i+1,j) - 2*Sim(i,j));
                Sim(i,j+1) = Sim(i,j) + dt * ((D * d2N) / (h^2));
                
            elseif(i == nvox) %The voxel at i+1 doesn't exist
                d2N = (-2*Sim(i,j) + 2*Sim(i-1,j));
                Sim(i,j+1) = Sim(i,j) + dt * ((D * d2N) / (h^2));
                
            else %Interior node, neighbors all exist
                d2N = (Sim(i+1,j) - 2*Sim(i,j) + Sim(i-1,j));
                Sim(i,j+1) = Sim(i,j) + dt * ((D * d2N) / (h^2));
            end
            
        end
    end

    %End of loop, save last point in Sim
    N = Sim(:,end);

end