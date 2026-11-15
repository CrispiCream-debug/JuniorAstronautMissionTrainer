varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
    // Descarta las sombras semitransparentes de los sprites.
    float silhouette = step(0.75, texture2D(gm_BaseTexture, v_vTexcoord).a);
    gl_FragColor = vec4(v_vColour.rgb, v_vColour.a * silhouette);
}
