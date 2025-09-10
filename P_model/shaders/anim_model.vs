#version 330 core

layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 norm;
layout(location = 2) in vec2 tex;
layout(location = 3) in vec3 tangent;
layout(location = 4) in vec3 bitangent;
layout(location = 5) in ivec4 boneIds; 
layout(location = 6) in vec4 weights;

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

const int MAX_BONES = 100;
const int MAX_BONE_INFLUENCE = 4;
uniform mat4 finalBonesMatrices[MAX_BONES];

// ---- outputs hacia el fragment shader ----
out vec2 TexCoords;
out vec3 FragPos;
out vec3 Normal;

void main()
{
    vec4 totalPosition = vec4(0.0f);
    vec3 totalNormal = vec3(0.0f);

    for(int i = 0 ; i < MAX_BONE_INFLUENCE ; i++)
    {
        if(boneIds[i] == -1) 
            continue;

        if(boneIds[i] >= MAX_BONES) 
        {
            totalPosition = vec4(pos,1.0f);
            totalNormal   = norm;
            break;
        }

        // aplicar huesos a la posición
        vec4 localPosition = finalBonesMatrices[boneIds[i]] * vec4(pos,1.0f);
        totalPosition += localPosition * weights[i];

        // aplicar huesos a la normal
        totalNormal += (mat3(finalBonesMatrices[boneIds[i]]) * norm) * weights[i];
    }

    // pasar coordenadas de textura
    TexCoords = tex;

    // posición en espacio mundial (para iluminación en el fragment shader)
    FragPos = vec3(model * totalPosition);

    // normal transformada correctamente
    Normal = mat3(transpose(inverse(model))) * totalNormal;

    // posición final de vértice en clip space
    gl_Position = projection * view * model * totalPosition;
}
