{ config, ... }: {
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffbffd" ];
}
