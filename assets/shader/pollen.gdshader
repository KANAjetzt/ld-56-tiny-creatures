shader_type canvas_item;

uniform int circle_count : hint_range(0, 20);
uniform float circle_radius : hint_range(0.01, 0.2);
uniform float circle_distance : hint_range(0.0, 1.0);
uniform vec4 circle_color : source_color;

void fragment() {
    if (circle_count == 0){
		discard;
	} else {
		// Get the current UV coordinates, center is at (0.5, 0.5)
    vec2 uv = UV;
    vec2 center = vec2(0.5, 0.5);

    // Calculate distance from center to current pixel
    float dist_to_center = distance(uv, center);

    // Start with the central circle
    float min_distance = dist_to_center - circle_radius;

    // Iterate over each additional circle
    for (int i = 0; i < circle_count - 1; i++) {
        float angle = float(i) / float(circle_count - 1) * 6.283185; // 2*PI for angle in radians
        vec2 circle_position = center + vec2(cos(angle), sin(angle)) * circle_distance;

        // Calculate distance to this circle and find the minimum distance
        float dist_to_circle = distance(uv, circle_position) - circle_radius;
        min_distance = min(min_distance, dist_to_circle);
    }

    // Smooth transition between inside and outside of circles
    float alpha = smoothstep(0.02, 0.0, min_distance);

    // Set the final color with the specified color and computed alpha
    COLOR = vec4(circle_color.rgb, alpha * circle_color.a);
	};
}
