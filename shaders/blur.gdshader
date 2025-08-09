shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 2.0; // Сила размытия
uniform float isigma : hint_range(0.1, 10.0) = 2.0; // Сигма для гауссова распределения
uniform int kernel_size : hint_range(1, 15) = 5; // Размер ядра (нечётное число)

float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0 * sigma * sigma)) / (sqrt(2.0 * PI) * sigma);
}

void fragment() {
    vec2 uv = UV;
    vec2 pixel_size = 1.0 / TEXTURE_PIXEL_SIZE; // Размер пикселя в UV-координатах
    vec4 color = vec4(0.0);
    float total_weight = 0.0;

    // Половина размера ядра
    int half_kernel = kernel_size / 2;

    // Считаем вклад соседних пикселей
    for (int x = -half_kernel; x <= half_kernel; x++) {
        for (int y = -half_kernel; y <= half_kernel; y++) {
            vec2 offset = vec2(float(x), float(y)) * blur_amount * pixel_size;
            float weight = gaussian(length(vec2(float(x), float(y))), isigma);
            color += texture(TEXTURE, uv + offset) * weight;
            total_weight += weight;
        }
    }

    // Нормализуем цвет
    COLOR = color / total_weight;
}