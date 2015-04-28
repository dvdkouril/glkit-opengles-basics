varying lowp vec4 DestinationColor;

uniform lowp float u_time;
//uniform lowp float u_resolution;

void main(void) {
    gl_FragColor = vec4(sin(DestinationColor.x+u_time), sin(DestinationColor.y+u_time), sin(DestinationColor.z+u_time), DestinationColor.a);
}
