# Scad-7300Controller

IC-7300 / IC-9700 リモートシステム向けの一体型ケースを生成する OpenSCAD プロジェクトです。  
`Raspberry Pi 4B` を搭載する前提で、下部ケースと上部カバーを出力できます。

## Files

- `case_final_complete.scad`: ケース本体の OpenSCAD スクリプト

## Requirements

- OpenSCAD

## Usage

OpenSCAD で `case_final_complete.scad` を開き、`mode` を切り替えて必要な形状を表示・書き出します。

```scad
// 0:組み立て, 1:分解, 2:下部のみ, 3:上部印刷用, 4:上部のみ
mode = 2;
```

### Mode

- `0`: 組み立て状態を表示
- `1`: 上下を離した分解表示
- `2`: 下部ケースのみ
- `3`: 上部カバーを印刷向きで表示
- `4`: 上部カバーのみ

## Main Parameters

- `case_w = 80`
- `case_l = 130`
- `case_h = 40`
- `wall_t = 2.5`
- `insert_boss_h = 8.0`
- `raspi_board_t = 1.6`

Raspberry Pi 4B の基準位置と、RJ-45 / USB-A 開口位置はスクリプト内で定義されています。  
現在の版では `Type-C` 用の開口は含めていません。

## Notes

- 寸法を変更する場合は、ケース外形だけでなくボス位置とコネクタ開口位置の整合も確認してください。
- 3D プリンタで出力する前に、OpenSCAD 上で各 `mode` を確認することを前提としています。
