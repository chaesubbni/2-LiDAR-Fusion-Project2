clear; clc;
lidar_data = load('lidar_data.mat');

lidar_1 = lidar_data.lidar_1;
lidar_2 = lidar_data.lidar_2;

%% 정압 과정.
x_1 = 0.94; 
y_1 = 0.49; 
z_1 = 1.76;
roll_1= 0.0; 
pitch_1 = 0.0; 
yaw_1 = -0.017453;
cos_r_1 = cos(roll_1); 
sin_r_1 = sin(roll_1);
cos_p_1 = cos(pitch_1); 
sin_p_1 = sin(pitch_1);
cos_y_1 = cos(yaw_1); 
sin_y_1 = sin(yaw_1);

r_matrix_1 = [1 0 0 0; 
0 cos_r_1 -sin_r_1 0;
0 sin_r_1 cos_r_1 0; 
0 0 0 1]; 


p_matrix_1 = [cos_p_1 0 sin_p_1 0; 
0 1 0 0;
-sin_p_1 0 cos_p_1 0; 
0 0 0 1];


y_matrix_1 = [cos_y_1 -sin_y_1 0 0; 
sin_y_1 cos_y_1 0 0;
0 0 1 0; 
0 0 0 1];

tl_matrix_1 = [1 0 0 x_1; 
0 1 0 y_1;
0 0 1 z_1; 
0 0 0 1];

tf_matrix_1 = tl_matrix_1 * y_matrix_1 * p_matrix_1 * r_matrix_1;

human_height = 0; %% 사람 키

human_1 = [];
for i = 1:length(lidar_1)
temp = [lidar_1(i,1); lidar_1(i,2); lidar_1(i,3); 1];
temp_2 = tf_matrix_1 * temp;
    if temp_2(1,1) > 6.5 && temp_2(1,1) < 7.5 && temp_2(3,1) > 0 && temp_2(3,1) < 1.8
        human_1 = [human_1; [temp_2(1,1) temp_2(2,1) temp_2(3,1)]];
        if human_height < temp_2(3,1)
            human_height = temp_2(3,1);
        end
    end
end



x_2 = 0.9649214;
y_2 = -0.52463; 
z_2 = 1.8305882;
roll_2 = 0.0049101; 
pitch_2 = 0.113957; 
yaw_2 = 0.0447597;
cos_r_2 = cos(roll_2); 
sin_r_2 = sin(roll_2);
cos_p_2 = cos(pitch_2); 
sin_p_2 = sin(pitch_2);
cos_y_2 = cos(yaw_2); 
sin_y_2 = sin(yaw_2);

r_matrix_2 = [1 0 0 0; 
0 cos_r_2 -sin_r_2 0;
0 sin_r_2 cos_r_2 0;
0 0 0 1 ];

p_matrix_2 = [cos_p_2 0 sin_p_2 0; 
0 1 0 0;
-sin_p_2 0 cos_p_2 0;
0 0 0 1 ];

y_matrix_2 = [cos_y_2 -sin_y_2 0 0; 
sin_y_2 cos_y_2 0 0;
0 0 1 0;
0 0 0 1 ];

tl_matrix_2 = [1 0 0 x_2; 
0 1 0 y_2;
0 0 1 z_2;
0 0 0 1];

tf_matrix_2 = tl_matrix_2 * y_matrix_2 * p_matrix_2 * r_matrix_2;

human_2 = [];
for i = 1:length(lidar_2)
    temp = [lidar_2(i,1); lidar_2(i,2); lidar_2(i,3); 1];
    temp_2 = tf_matrix_2 * temp;
    if temp_2(1,1) > 6.5 && temp_2(1,1) < 7.5 && temp_2(3,1) > 0 && temp_2(3,1) < 1.8
        human_2 = [human_2; [temp_2(1,1) temp_2(2,1) temp_2(3,1)]];
        if human_height < temp_2(3,1)
            human_height = temp_2(3,1);
        end
    end
end

fprintf('human height: %.2f\n', human_height);

car_data=stlread('hyundai_i30.stl');
car_x=car_data.vertices(:,1)';
car_y=car_data.vertices(:,2)';
car_z=car_data.vertices(:,3)';
car=[car_x;car_y;car_z;ones(1,length(car_x))];
car_roll=90/180*pi; car_yaw=90/180*pi;

R_car_roll=[1 0 0 0;
0 cos(car_roll) -sin(car_roll) 0;
0 sin(car_roll) cos(car_roll) 0;
0 0 0 1];

R_car_yaw=[cos(car_yaw) -sin(car_yaw) 0 0;
sin(car_yaw) cos(car_yaw) 0 0;
0 0 1 0;
0 0 0 1]; 

car_re= R_car_yaw * R_car_roll * car;

car_zdot=-min(car_re(3,:))+0.2; %%  자동차 그림이 0.2 공중에 떠 있음.

lift_height = 0.2; %% 자동차가 공중에 띄어진 값.
fprintf('lift height: %d\n', lift_height); %% 리프트 높이 출력.

y_temp=sort(car_re(2,:));
car_ydot=-y_temp(118278/2);
car_xdot=-1.8;

L_car=[1 0 0 car_xdot; 
0 1 0 car_ydot; 
0 0 1 car_zdot; 
0 0 0 1];

car_re=L_car *car_re;


%% 자동차의 제일 끝 부분
[max_car_x, idx_max_x] = max(car_re(1,:));
car_point = car_re(1:3, idx_max_x);

% 사람과 car_point의 최소 거리 계산
distance = 100; %% 초기값 100으로 설정함. 

for i = 1:size(human_1,1)
   d = sqrt(sum((car_point - human_1(i, 1:3)').^2));
   if distance > d
       distance = d;
   end
end


for i = 1:size(human_2,1)
   d = sqrt(sum((car_point - human_2(i, 1:3)').^2));
   if distance > d
       distance = d;
   end
end

fprintf('min distance: %.2f\n', distance);

figure(); hold on; title('');
plot3(human_1(:,1), human_1(:,2), human_1(:,3), '.b', 'MarkerSize',5);
plot3(human_2(:,1),human_2(:,2),human_2(:,3),'.b','MarkerSize',5);
plot3(car_re(1,:),car_re(2,:),car_re(3,:),'k.')

view([0 -90 0]);
title('Lidar data (after calibration)'); axis equal; grid on; 
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');