# MELPe_fxp

Fork of [osherbakov/MELPe_fxp](https://github.com/osherbakov/MELPe_fxp), the fixed-point
MELPe (STANAG 4591, 2400 / 1200 b/s) reference coder, made to build and run on 64-bit
Linux and macOS (x86-64 and aarch64), stripped to the sources of the `melpe` binary.

## Build

```bash
make        # -> ./melpe
```

## Usage

Speech is raw 8 kHz mono 16-bit little-endian PCM.

```bash
./melpe -i in.raw -o out.raw            # encode + decode, 2400 b/s
./melpe -a -i in.raw -o bits.bin        # analysis (encode) only
./melpe -s -i bits.bin -o out.raw       # synthesis (decode) only
./melpe -l ...                          # 1200 b/s instead of 2400
./melpe -u / -d ...                     # transcode 1200 -> 2400 / 2400 -> 1200 b/s
./melpe -p ...                          # unpacked bitstream (backward compatibility)
./melpe -h                              # help
```

## Changes against upstream

- `sc1200.h`: the 32-bit types come from `<stdint.h>`. Upstream typedefs `int32_t` as
  `long`, which is 64 bits on LP64, and `norm_l()` then loops forever.
- `constant.h`: `LW_MIN` / `LW_MAX` / `LW_SIGN` cast to `int32_t` instead of `long`.
- The 16-bit `round()` basic op is renamed `round16()`: it clashed with libm's `round`.
- `fft_lib.c`: the twiddle tables have one more entry, as `cfft()` reads one past the end.
- `sc1200.c`: `main()` passes the real command line to `main_cmd()` instead of the
  hard-wired `test_in.raw` / `test_out.raw`.
- `Makefile`: builds with `-fwrapv`, which the basic ops need (they rely on wrapping
  signed overflow).
- Removed: the Keil / Cortex-M port (`ARM/`, `Build/Keil`, the CMSIS include in
  `sc1200.h`), the Visual Studio project, the test files and Windows tools in
  `Build/Test_files`, and the stale `sc12enc.c` / `sc12dec.c` / `sc24enc.c` / `sc24dec.c`
  drivers. `Win32/mathhalf.c` (the portable basic ops) moved to `mathhalf.c`.
