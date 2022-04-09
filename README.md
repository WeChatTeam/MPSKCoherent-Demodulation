# Coherent demodulation of M-PSK in FPGA
概述

将M-PSK信号的符号同步部署到了FPGA上，目前只做了前仿真，过段时间有空了再做后仿真。我也在准备把载波同步部署上去，已经在Matlab上做了算法的原型验证，但是涉及到三角函数和开方，部署的化还没那么快。

---

## 文件结构
├─data  
├─sim  
│  ├─sim.config  
│  └─sim.src  
├─src  
│  ├─carrierSync  
│  ├─DFF  
│  └─SymbolSync  
├─Sync.hw  
├─Sync.ip_user_files  
└─Sync.sim

## 符号同步
采用加纳算法来实现符号同步，一共包含5个步骤：`内插滤波器`，`误差检测器`，`环路滤波器`，`脉冲有效控制器`，`重采样模块`。
