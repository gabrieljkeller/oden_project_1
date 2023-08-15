%% Test problem 2 (testing gabriel's script)
% 2d
FOV_x = 200; %total FOV (mm)
FOV_y = 200;

h   = 2; %grid spacing (mm)

nx = FOV_x/h;
ny = FOV_y/h;


%Build emtpy matrix
x = 1:nx;
y = 1:ny;
[X,Y] = meshgrid(x,y);

N0 = zeros(nx,ny);
N0 = N0 + 100 * ((X - nx/2).^2 + (Y - ny/2).^2 <= 10^2); %add circle of cells

%graph day 0
subplot(1,2,1)
imagesc(x,y,N0);
impixelinfo;
colorbar
axis('on', 'image');
title("NTC Map Day 0", 'FontSize', 15)

%now run simulation
t = 2; %Run for 30 days
dt = 0.5; %Time step
D = 0.0005;
k = 0.05;

tic
N_new = Diffusion_2D(N0, D, h, dt, t, k);
toc

%graph day 30
subplot(1,2,2)
imagesc(x,y,N_new);
impixelinfo;
colorbar
axis('on', 'image');
title("NTC Map Day 30", 'FontSize', 15)

%% Test problem 1
%1D Domain

FOV = 200; %total FOV (mm)
h   = 2; %grid spacing (mm)

nx = FOV/h; %num of voxels

%Build emtpy matrix
N0 = zeros(1,nx);

%Initialize some cells
N0(nx*0.4:nx*0.6) = 1.0;

%Visualize the cells in space
xloc = linspace(0,FOV,nx);
figure
plot(xloc, N0, 'LineWidth', 2, 'DisplayName', 'Initial');
xlabel('Location (mm)'); ylabel('Volume fraction');
hold on
title('Problem 1 - Example');


t = 30; %Run for 30 days
dt = 0.5; %Time step

D = 1;

N_new = Diffusion_1D(N0, D, h, dt, t);

plot(xloc, N_new, 'LineWidth', 2, 'DisplayName', ['D = ',num2str(D)]);
legend;

%% Test for changing diffusivity
figure
subplot(1,2,1)
plot(xloc, N0, 'LineWidth', 2, 'DisplayName', 'Initial');
xlabel('Location (mm)'); ylabel('Volume fraction');
hold on
sgtitle('Problem 2 - Changing D');

%Create a vector of test diffusivities
D_vec = [0.1, 1, 2, 3];

for i = 1:length(D_vec)
    %{
        TODO
        run each diffusivity and plot, make note of what changes
    %}
    D = D_vec(i);
    
    
    %Simulation runs here
    N_new = Diffusion_1D(N0, D, h, dt, t);
    
    
    %Plot here
    % subplot(1,2,i+1)
    plot(xloc, N_new, 'LineWidth', 2, 'DisplayName', ['D = ',num2str(D)]);
    
    
end
legend;

%Now compare what happens with D >= 4
D = 4;
N_new = Diffusion_1D(N0, D, h, dt, t);

subplot(1,2,2)
plot(xloc, N0, 'LineWidth', 2, 'DisplayName', 'Initial');
xlabel('Location (mm)'); ylabel('Volume fraction');
hold on
plot(xloc, N_new, 'LineWidth', 2, 'DisplayName', ['D = ',num2str(D)]);
legend;



%% Test for changing time step
figure
subplot(1,2,1)
plot(xloc, N0, 'LineWidth', 2, 'DisplayName', 'Initial');
xlabel('Location (mm)'); ylabel('Volume fraction');
hold on
sgtitle('Problem 3 - Changing time step');

%Create a vector of test time steps
dt_vec = [0.1, 0.25, 0.5, 1.5];

D = 1;

for i = 1:length(dt_vec)
    start = tic;
    %{
        TODO
        run each time step and plot, make note of what changes
    %}
    dt = dt_vec(i);
    
    
    %Simulation runs here
    N_new = Diffusion_1D(N0, D, h, dt, t);
    
    stop = toc(start);
    disp(['Run time, dt=',num2str(dt),', is ',num2str(stop),' seconds']);
    
    
    %Plot here
    plot(xloc, N_new, 'LineWidth', 2, 'DisplayName', ['dt = ',num2str(dt)]);
    
    
end
legend;

%Now compare what happens with dt >= 2 days
dt = 2;
N_new = Diffusion_1D(N0, D, h, dt, t);

subplot(1,2,2)
plot(xloc, N0, 'LineWidth', 2, 'DisplayName', 'Initial');
xlabel('Location (mm)'); ylabel('Volume fraction');
hold on
plot(xloc, N_new, 'LineWidth', 2, 'DisplayName', ['dt = ',num2str(dt)]);
legend;

%% Test for changing space step
figure
subplot(1,2,1)
plot(xloc, N0, 'LineWidth', 2, 'DisplayName', 'Initial');
xlabel('Location (mm)'); ylabel('Volume fraction');
hold on
sgtitle('Problem 4 - Changing space step');

%Create a vector of test space steps
h_vec = [1, 2, 4, 8];

dt = 0.5;
D = 1;

for i = 1:length(h_vec)
    %{
        TODO
        run each space step and plot, make note of what changes
    %}
    h = h_vec(i);
    xloc_new = linspace(0,FOV,FOV/h);
    
    %Rebuild N0 to match space step
    N0_new = interp1(xloc, N0, xloc_new); %This is now used for the function call
    
    
    
    %Simulation runs here
    
    
    
    %Plot here
    
end
legend;

%Now compare what happens with h < 1.0
h = 0.9;
xloc_new = linspace(0,FOV,FOV/h);
N0_new = interp1(xloc, N0, xloc_new);
N_new = Diffusion_1D(N0_new, D, h, dt, t);

subplot(1,2,2)
plot(xloc, N0, 'LineWidth', 2, 'DisplayName', 'Initial');
xlabel('Location (mm)'); ylabel('Volume fraction');
hold on
plot(xloc_new, N_new, 'LineWidth', 2, 'DisplayName', ['h = ',num2str(h)]);
legend;