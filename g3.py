#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""g3.py — bangun fluent3.lua (LinoriaLib, 3 TAB: Home/Farmx/Progress) dari fluent2.lua.

Asas: SEMUA logika + plumbing state + shim addStatusRow + blok build Home/Farm/Progress
disalin VERBATIM (anchor dinamis). Hanya 4 zona yang DIREPLACE:
  Z1 loader Fluent (2182-2196)         -> loader LinoriaLib
  Z2 r.notify (2256-2266)              -> r.notify versi Linoria (nama/signature SAMA)
  Z3 helpers addToggle..addSectionSafe (2305-2490) -> shim Linoria (signature SAMA)
  Z4 blok build 7-tab (2491-2739)      -> blok build 3-TAB (Home/Farmx/Progress verbatim)
plus tail r.unload Fluent:Destroy (1 baris) -> Linoria unload.
Hasil bisa diverifikasi: luau-compile.""" distamakan diri.
