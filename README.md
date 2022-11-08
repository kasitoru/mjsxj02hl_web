# mjsxj02hl_web

[![Donate](https://img.shields.io/badge/donate-YooMoney-blueviolet.svg)](https://yoomoney.ru/to/4100110221014297)

WEB interface for mjsxj02hl firmware

**Attention! This firmware is no longer supported by the author. We recommend using [OpenIPC](https://github.com/OpenIPC/device-mjsxj02hl).**


## Dependencies

Hi3518Ev300 [toolchain](https://dl.openipc.org/SDK/HiSilicon/Hi3516Ev200_16Ev300_18Ev300/Hi3516EV200R001C01SPC011/arm-himix100-linux.tgz):

```bash
tar -zxf arm-himix100-linux.tgz
sudo ./arm-himix100-linux.install
```

Others:

```bash
sudo apt install git dos2unix
```

## Build

### Download source files and compile:

```bash
make all
```

### Remove all generated files:
```bash
make clean
```
