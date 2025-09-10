#version 330 core
layout (location = 0) in vec3 aPos;       // posición del vértice
layout (location = 1) in vec3 aNormal;    // normal del vértice
layout (location = 2) in vec2 aTexCoords; // coordenadas UV

out vec3 FragPos;     // posición en espacio mundo para el frag shader
out vec3 Normal;      // normal transformada
out vec2 TexCoords;   // coordenadas de textura

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main()
{
    // Posición del vértice en espacio mundo
    FragPos = vec3(model * vec4(aPos, 1.0));
    
    // Normal transformada correctamente (usar la matriz normal)
    Normal = mat3(transpose(inverse(model))) * aNormal;
    
    // Pasar coordenadas de textura
    TexCoords = aTexCoords;    

    // Transformación final al espacio clip
    gl_Position = projection * view * vec4(FragPos, 1.0);
}
