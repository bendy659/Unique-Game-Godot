shader_type spatial;
render_mode cull_front, unshaded;

uniform vec4 outline_color : source_color;
uniform float outline_size = 0.1;
uniform bool visible = true;

void vertex() { if(visible) { VERTEX += NORMAL * outline_size; } }
void fragment() { ALBEDO = outline_color.rgb; }
