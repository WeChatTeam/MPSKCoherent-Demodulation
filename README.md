# Coherent demodulation of M-PSK in FPGA
概述

将M-PSK信号的符号同步部署到了FPGA上，目前只做了前仿真，过段时间有空了再做后仿真。我也在准备把载波同步部署上去，已经在`Matlab`上做了算法的原型验证，但是涉及到三角函数和开方，部署的化还没那么快。

---

## 文件结构
`src.SymbolSync`：符号同步的代码。  
`src.DFF`：  各种标准DFF，copy自我的另一个 [项目](https://github.com/WeChatTeam/StandardDFF.git)。  
`src.carrierSync`：载波同步的代码，目前还不完善。  
`data`：未解调的M-PSK信号，以及一个浮点数转定点数的`Matlab`脚本。  
`sim.src`：符号同步的激励文件，以及每个模块单独的测试激励文件。
`sim.config`：Xsim仿真环境的配置参数。

---

## 符号同步
采用加纳算法来实现符号同步，一共包含5个步骤：`内插滤波器`，`误差检测器`，`环路滤波器`，`脉冲有效控制器`，`重采样模块`。
