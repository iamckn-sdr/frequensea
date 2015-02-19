-- Animate the camera around a static scene

VERTEX_SHADER = [[
#ifdef GL_ES
attribute vec3 vp;
attribute vec3 vn;
varying vec3 color;
#else
#version 400
layout (location = 0) in vec3 vp;
layout (location = 1) in vec3 vn;
out vec3 color;
#endif
uniform mat4 uViewMatrix, uProjectionMatrix;
uniform float uTime;
void main() {
    color = vec3(1.0, 1.0, 1.0) * dot(normalize(vp), normalize(vn)) * 0.3;
    color += vec3(0.1, 0.1, 0.5);
    gl_Position = uProjectionMatrix * uViewMatrix * vec4(vp, 1.0);
}
]]

FRAGMENT_SHADER = [[
#ifdef GL_ES
precision mediump float;
varying vec3 color;
void main() {
    gl_FragColor = vec4(color.r,color.g,color.b, 0.95);
}

#else

#version 400
in vec3 color;
layout (location = 0) out vec4 fragColor;
void main() {
    fragColor = vec4(color, 0.95);
}
#endif
]]

function setup()
    model = ngl_model_load_obj("../obj/c004.obj")
    shader = ngl_shader_new(GL_TRIANGLES, VERTEX_SHADER, FRAGMENT_SHADER)
end

function draw()
    camera_x = math.sin(nwm_get_time() * 0.3) * 50
    camera_y = 10
    camera_z = math.cos(nwm_get_time() * 0.3) * 50

    camera = ngl_camera_new_look_at(camera_x, camera_y, camera_z)
    ngl_clear(0.2, 0.2, 0.2, 1)
    ngl_draw_model(camera, model, shader)
end
