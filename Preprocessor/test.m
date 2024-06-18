global Mesh_Ratios_handle
% 1. Simulation name
Simulation_Name='fault';

load_rate = 0.01; %m/s
pressure = 45E6; %MPa
mat_file=load('grainfiles\fault.mat');
fault_width = mat_file.fault_width/1000; %mm
fault_angle = mat_file.fault_angle;  %degree
model_height= mat_file.model_height/1000; %mm
model_width = mat_file.model_width/1000;  %mm
ContoursGrains=mat_file.Contours;
SampleProperties = mat_file.SampleProperties;
DomainPoints = mat_file.DomainPoints/1000;
Ngrains=size(ContoursGrains,1);
first_bodies=3;
numcpus = systeminfo();

offset = (DomainPoints(1,1)+DomainPoints(3,1))/2;
DomainPoints(:,1) = DomainPoints(:,1)-offset;
% 2. Initilization
Contours=cell(1,1);
Distributions=cell(1,1);
Interpolations=cell(1,1);
Integrations=cell(1,1);
Bodies_Materials=cell(1,1);
Imposed_Pressures=cell(1,1);
Imposed_Velocities=cell(1,1);
Alid=cell(1,1);
Deactivations=cell(1,1);
To_Plot=zeros(44,1);

% 3. Bodies
xmintemp = -model_width/2;
xmaxtemp = -xmintemp;
ymintemp = -0.0001;
ymaxtemp = 0;
Contours{1,1}={'Closed',[xmintemp,ymintemp;xmaxtemp,ymintemp;xmaxtemp,ymaxtemp;xmintemp,ymaxtemp],'Linear'};
Distributions{1,1}={'Rigid'};
Distributions{1,2}=5e-5;
Distributions{1,3}=numcpus;
Interpolations{1,1}='MLS';
Interpolations{1,2}=10;
Integrations{1,1}='Gauss';
Integrations{1,2}=3;
Detections(1,1)=1e-5;
Detections(1,2)=1e-5;
Bodies_Materials{1,1}='baserock';
Imposed_Pressures{1,1}={[],'None',[],'None';...
    [],'None',[],'None';...
    };
Imposed_Velocities{1,1}={[0,0;1e6,0],'Driven',[],[0,0;1e6,0],'Driven',[];...
    [],'None',[],[],'None',[];...
    };
Initial_Velocities{1,1}=[0,0];
Mesh_Ratios(1,1:2)=[4,1];
Status{1,1}='active';
Alid{1,1}=[];
Alid{1,2}=[];
Alid{1,3}=[];

Contours{2,1}={'Simple',[-model_width/2,0;DomainPoints(1,1),DomainPoints(1,2)],'Linear',4,2;...
    'Simple',[DomainPoints(1,1),DomainPoints(1,2);DomainPoints(4,1),DomainPoints(4,2)],'Linear',1,3;...
     'Simple',[DomainPoints(4,1),DomainPoints(4,2);-model_width/2,model_height],'Linear',2,4;...
      'Simple',[-model_width/2,model_height;-model_width/2,0],'Linear',3,1};
Distributions{2,1}={'Unstructured'};
Distributions{2,2}=2E-5;
Distributions{2,3}=numcpus;
Interpolations{2,1}='MLS';
Interpolations{2,2}=10;
Integrations{2,1}='Gauss';
Integrations{2,2}=3;
Detections(2,1)=5e-6;
Detections(2,2)=5e-6;
Bodies_Materials{2,1}='Rock';
Imposed_Pressures{2,1}={[],'None',[],'None';...
    [],'None',[],'None';...
    [],'None',[],'None';...
    [0,pressure;1e6,pressure],'Oriented',[],'None' ...
    };
%note the driven is only applicable for rigids!
Imposed_Velocities{2,1}={[],'None',[],[],'None',[];...
    [],'None',[],[],'None',[];...
    [],'None',[],[0,0;1e-4,0;2e-4,-load_rate;1e6,-load_rate],'Soft',[1e15,0.3];...
    [],'None',[],[],'None',[]};
Initial_Velocities{2,1}=[0,0];
Mesh_Ratios(2,1:2)=[-1,1];
fh_left = fh_line([DomainPoints(1,1),DomainPoints(1,2);DomainPoints(4,1), ...
    DomainPoints(4,2)],2e-5,1e-4,fault_width);
Mesh_Ratios_handle{1,1} = fh_left;
Status{2,1}='active';
Alid{2,1}=[];
Alid{2,2}=[];
Alid{2,3}=[];
% 
Contours{3,1}={'Simple',[DomainPoints(2,1),DomainPoints(2,2);model_width/2,0],'Linear',4,2;...
    'Simple',[model_width/2,0;model_width/2,model_height],'Linear',1,3;...
     'Simple',[model_width/2,model_height;DomainPoints(3,1),DomainPoints(3,2)],'Linear',2,4;...
      'Simple',[DomainPoints(3,1),DomainPoints(3,2);DomainPoints(2,1),DomainPoints(2,2)],'Linear',3,1};
Distributions{3,1}={'Unstructured'};
Distributions{3,2}=2E-5;
Distributions{3,3}=numcpus;
Interpolations{3,1}='MLS';
Interpolations{3,2}=10;
Integrations{3,1}='Gauss';
Integrations{3,2}=3;
Detections(3,1)=5e-6;
Detections(3,2)=5e-6;
Bodies_Materials{3,1}='Rock';
Imposed_Pressures{3,1}={[],'None',[],'None';...
    [0,-pressure;1e6,-pressure],'Oriented',[],'None';...
    [],'None',[],'None';...
    [],'None',[],'None';...
    };
%note the driven is only applicable for rigids!
Imposed_Velocities{3,1}={[],'None',[],[],'None',[];...
    [],'None',[],[],'None',[];...
    [],'None',[],[],'None',[];...
    [],'None',[],[],'None',[]};
Initial_Velocities{3,1}=[0,0];
fh_right = fh_line([DomainPoints(3,1),DomainPoints(3,2);DomainPoints(2,1), ...
    DomainPoints(2,2)],2e-5,1e-4,fault_width);
Mesh_Ratios(3,1:2)=[-1,2];
Mesh_Ratios_handle{2,1} = fh_right;
Status{3,1}='active';
Alid{3,1}=[];
Alid{3,2}=[];
Alid{3,3}=[];
% % 
% Contours{3,1}={'Simple',[DomainPoints(2,1),DomainPoints(2,2);model_width/2,0],'Linear',4,2;...
%     'Simple',[model_width/2,0;model_width/2,model_height],'Linear',1,3;...
%      'Simple',[model_width/2,model_height;DomainPoints(3,1),DomainPoints(3,2)],'Linear',2,4;...
%       'Simple',[DomainPoints(3,1),DomainPoints(3,2);DomainPoints(2,1),DomainPoints(2,2)],'Linear',3,1};
% Distributions{3,1}={'Unstructured'};
% Distributions{3,2}=2E-5;
% Distributions{3,3}=numcpus;
% Interpolations{3,1}='MLS';
% Interpolations{3,2}=10;
% Integrations{3,1}='Gauss';
% Integrations{3,2}=3;
% Detections(3,1)=5e-6;
% Detections(3,2)=5e-6;
% Bodies_Materials{3,1}='Rock';
% Imposed_Pressures{3,1}={[],'None',[],'None';...
%     [0,-pressure;1e6,-pressure],'Oriented',[],'None';...
%     [],'None',[],'None';...
%     [],'None',[],'None';...
%     };
% %note the driven is only applicable for rigids!
% Imposed_Velocities{3,1}={[],'None',[],[],'None',[];...
%     [],'None',[],[],'None',[];...
%     [],'None',[],[],'None',[];...
%     [],'None',[],[],'None',[]};
% Initial_Velocities{3,1}=[0,0];
% fh_right = fh_line([DomainPoints(3,1),DomainPoints(3,2);DomainPoints(2,1),DomainPoints(2,2)],2e-5,2e-4,fault_width);
% Mesh_Ratios(2,1:2)=['umr',fh_right];
% Mesh_Ratios(3,1:2)=[1,4];
% Status{3,1}='active';
% Alid{3,1}=[];
% Alid{3,2}=[];
% Alid{3,3}=[];
% 
% for num=1:Ngrains
%     %mm to m
%     xydata = ContoursGrains{num,1}/1000;
%     Contours{first_bodies+num,1}={'Closed',[xydata(:,1)-offset,xydata(:,2)],'Linear'};   
%     Distributions{first_bodies+num,1}={'Rigid'};
% 
%     perimeter = SampleProperties(num,7)/1000; % m units
%     Distributions{first_bodies+num,2} = perimeter/10;
%     Distributions{first_bodies+num,3}=6;
%     Interpolations{first_bodies+num,1}='MLS';
%     Interpolations{first_bodies+num,2}=10;
%     Integrations{first_bodies+num,1}='Gauss';
%     Integrations{first_bodies+num,2}=3;
%     Detections(first_bodies+num,1)=5e-6;
%     Detections(first_bodies+num,2)=5e-6;
%     Bodies_Materials{first_bodies+num,1}='Gouge';
%     Imposed_Pressures{first_bodies+num,1}={[],'None',[],'None';...
%                             };
%     Imposed_Velocities{first_bodies+num,1}={[],'None',[],[],'None',[];...
%                              };
%     Initial_Velocities{first_bodies+num,1}=[0,0];
%     Mesh_Ratios(first_bodies+num,1:2)=[1,1];
%     Status{first_bodies+num,1}='active';
%     Alid{first_bodies+num,1}=[];
%     Alid{first_bodies+num,2}=[];
%     Alid{first_bodies+num,3}=[];
% end

% 4. Materials and contact laws
Materials={'baserock','NeoHookean',[2700,0,0,0,0,0];...
           'Gouge','NeoHookean',[2700,0,0,0,0,0];...
           'Rock','NeoHookean',[2700,0,0,70e9,0.29,0];...
           };
Contact_Laws={'Gouge','Gouge','CZMlinear','Evolutive',[4e15,50e6,0.2e-6,10e6,1,1e-5,0.3];...
    'Gouge','baserock','CZMlinear','Evolutive',[4e15,50e6,0.2e-6,10e6,1,1e-5,0.3];...
    'Gouge','Rock','CZMlinear','Evolutive',[4e15,50e6,0.2e-6,10e6,1,1e-5,0.3];...
    'Rock','baserock','DampedMohrCoulomb','Evolutive',[4e+15,4e+15,0.5,0,0,0.3];...     
    };

% 5. General boundary conditions
Periodic_Boundaries=[-model_width,model_width];
Gravity=[0;-9.8];

% 6. Text outputs
Monitorings=cell(1,1);
Spies={'FORCE_DISP',4,1e-6,{'Displacement X 1 -1';...
                            'Displacement Y 1 -1';...
                            'Force X Contact 1 -1';...
                            'Force Y Contact 1 -1';...
                            };
      };


% 7. Graphic outputs
To_Plot(1)=1;   % Body Index
To_Plot(2)=1;   % Initial Position
To_Plot(3)=0;   % Current Position
To_Plot(4)=1;   % Displacement
To_Plot(5)=1;   % Velocity
To_Plot(6)=0;   % Acceleration
To_Plot(7)=1;   % Force
To_Plot(8)=0;   % Internal Force
To_Plot(9)=0;   % Contact Force
To_Plot(10)=0;  % Body Force
To_Plot(11)=0;  % Dirichlet Force
To_Plot(12)=1;  % Neumann Force
To_Plot(13)=0;  % Damping Force
To_Plot(14)=0;  % Alid Force
To_Plot(15)=0;  % Jacobian
To_Plot(16)=0;  % Cauchy XX Stress
To_Plot(17)=0;  % Cauchy YY Stress
To_Plot(18)=0;  % Cauchy XY Stress
To_Plot(19)=0;  % Cauchy ZZ Stress
To_Plot(20)=0;  % Tresca Stress
To_Plot(21)=0;  % Von Mises Stress
To_Plot(22)=0;  % Major Principal Stress
To_Plot(23)=0;  % Intermediate Principal Stress
To_Plot(24)=0;  % Minor Principal Stress
To_Plot(25)=0;  % Spherical Stress
To_Plot(26)=0;  % Green-Lagrange XX strain
To_Plot(27)=0;  % Green-Lagrange YY strain
To_Plot(28)=0;  % Green-Lagrange XY strain
To_Plot(29)=0;  % Norm of the Green-Lagrange strain tensor
To_Plot(30)=1;  % Body Damage
To_Plot(31)=1;  % Body Relative Damage
To_Plot(32)=0;  % Normalized Displacement Error
To_Plot(33)=0;  % Displacement Error
To_Plot(34)=0;  % Internal Work
To_Plot(35)=0;  % Contact Work
To_Plot(36)=0;  % Body Work
To_Plot(37)=0;  % Dirichlet Work
To_Plot(38)=0;  % Neumann Work
To_Plot(39)=0;  % Damping Work
To_Plot(40)=0;  % Alid Work
To_Plot(41)=0;  % Temperature
To_Plot(42)=0;  % Scaling Parameter
To_Plot(43)=0;  % Active Contacts
To_Plot(44)=0;  % Contacting Bodies

Chains_Parameters = [45e6,1];
Fields_Parameters = [-fault_width/2 DomainPoints(3,1) 0 model_height 0.0005 0.0001];

% 8. Numerical parameters
Scheme='Adaptive_Euler';
Scheme_Parameters=[0.0001 0.2 10];
Contact_Updating_Period=1e-8;
Time_Stepping_Parameters=[0,0.2e-9,0.002];
Save_Periods=[0.00005,0.00005];

% 9. Flags
Activate_Plot=0;
Initialize_CZM=1;                                                                                                                                                                            