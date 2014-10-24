function figure_handler = draw_graph(time, signal_name, signal_data, target, vedio_index)

figure_handler = figure;
plot(time, signal_data);
hold on

% assume 1 means lane change (LC) and 0 means no lane change (NLC)
lane_change_points = find(target == 1);       % find the index list where lane chagne happened
no_lane_change_points = find(target == 0);

lane_change_start_points = lane_change_points(1);
lane_change_end_points = [];
for i = 1:( length(lane_change_points) - 1 )
    if (lane_change_points(i+1) > (lane_change_points(i) + 2) )
        lane_change_start_points = [lane_change_start_points, lane_change_points(i+1)];
        lane_change_end_points = [lane_change_end_points, lane_change_points(i)];
    end
end
lane_change_end_points = [lane_change_end_points, lane_change_points(end)];

no_lane_change_start_points = no_lane_change_points(1);
no_lane_change_end_points = [];
for i = 1:( length(no_lane_change_points) - 1 )
    if (no_lane_change_points(i+1) > (no_lane_change_points(i) + 2) )
        no_lane_change_start_points = [no_lane_change_start_points, no_lane_change_points(i+1)];
        no_lane_change_end_points = [no_lane_change_end_points, no_lane_change_points(i)];
    end
end
no_lane_change_end_points = [no_lane_change_end_points, no_lane_change_points(end)];

num_lane_change_event = length(lane_change_start_points);
for k = 1:num_lane_change_event
    start_point = lane_change_start_points(k);
    end_point = lane_change_end_points(k);
    plot(time(start_point:end_point), signal_data(start_point:end_point), 'r', 'LineWidth', 2);
end

title(['Vedio ', num2str(vedio_index), '- signal: ', signal_name], 'FontSize', 12);
xlabel('time of data point (s)', 'FontSize', 12);

hold off