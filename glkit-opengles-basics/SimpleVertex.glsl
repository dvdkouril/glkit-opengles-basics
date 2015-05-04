attribute vec4 Position;
attribute vec4 SourceColor;

varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 ModelView;
uniform float u_time;

void main(void) {
    DestinationColor = SourceColor;
    //gl_Position = Position;
    gl_Position = Projection * ModelView * Position;
}
