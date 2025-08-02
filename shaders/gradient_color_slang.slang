
RWTexture2D<half4> image; // : register(u0); // or [[vk::binding(0)]]

struct PushConstants
{
    float4 data1;
    float4 data2;
    float4 data3;
    float4 data4;
};

[numthreads(16, 16, 1)]
[shader("compute")]
void main(uint3 dispatchThreadID: SV_DispatchThreadID,
          uint3 groupThreadID: SV_GroupThreadID,
          uniform PushConstants pushBlock)
{
    int2 texelCoord = int2(dispatchThreadID.xy);
    int2 size;
    image.GetDimensions(size.x, size.y);

    float4 topColor = pushBlock.data1;
    float4 bottomColor = pushBlock.data2;

    if (texelCoord.x < size.x && texelCoord.y < size.y)
    {
        float blend = float(texelCoord.y) / (size.y);

        image[texelCoord] = half4(lerp(topColor, bottomColor, blend));
    }
}
