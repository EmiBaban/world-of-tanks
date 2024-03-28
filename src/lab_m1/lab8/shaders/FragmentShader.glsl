#version 330

// Input
in vec3 world_position;
in vec3 world_normal;

// Uniforms for light properties
uniform vec3 light_direction;
uniform vec3 eye_position;

uniform vec3 point_light_pos[2];

uniform float material_kd;
uniform float material_ks;
uniform int material_shininess;
uniform int typeLight;

// TODO(student): Declare any other uniforms

uniform vec3 object_color;

// Output
layout(location = 0) out vec4 out_color;

float point_light_contribution(vec3 light_pos)
{
	vec3 L = normalize( light_pos - world_position);
    vec3 V = normalize( eye_position - world_position);
    vec3 H = normalize( L + V );
    vec3 R = reflect(-L, world_normal);
    // TODO(student): Define ambient, diffuse and specular light components
    float ambient_light = 0.25;

    // TODO(student): Compute diffuse light component
    float diffuse_light = material_kd * max (dot(world_normal, L), 0);

    // TODO(student): Compute specular light component
    float specular_light = 0;
    // It's important to distinguish between "reflection model" and
    // "shading method". In this shader, we are experimenting with the Phong
    // (1975) and Blinn-Phong (1977) reflection models, and we are using the
    // Phong (1975) shading method. Don't mix them up!
    if (diffuse_light > 0)
    {
        specular_light = material_ks * pow(max(0, dot(V, R)), material_shininess);
    }
     float light;
    // TODO(student): If (and only if) the light is a spotlight, we need to do
    // some additional things.

    if (typeLight == 0) {
        float d = distance(light_pos, world_position);
	    float attenuation_factor = 1 / (1 + 0.14 * d + 0.07 * d * d);
	    light = ambient_light + attenuation_factor * (diffuse_light + specular_light);
    } 
    else if (typeLight == 1) {
        if (dot(-L, light_direction) > cos( radians(30))) {
			float linear_att = (dot(-L, light_direction) - cos( radians(30))) / (1 - cos( radians(30)));
			float light_att_factor = pow(linear_att, 2);
			light = ambient_light + light_att_factor * (diffuse_light + specular_light);
		}
		else
			light = ambient_light;
    }
    return light;
}

void main()
{
     
    // TODO(student): Compute the total light. You can just add the components
    // together, but if you're feeling extra fancy, you can add individual
    // colors to the light components. To do that, pick some vec3 colors that
    // you like, and multiply them with the respective light components.

    // TODO(student): Write pixel out color
    float light1 = point_light_contribution(point_light_pos[0]);
    float light2 = point_light_contribution(point_light_pos[1]);

    out_color = vec4(object_color * (light1 + light2), 1.f);

}
