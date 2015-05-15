n = 15;
wp = zeros(n^2,2);
idx = n^2;
for i=1:n
	for j=1:n
		wp(idx,:) = [i j];
		idx = idx - 1;
	end
end
wp=wp*500;

waypointList={wp};