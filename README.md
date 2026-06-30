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
- 蓋固定用ボス（四隅）外径: `7.5 mm` (`lid_boss_d`)
- Raspberry Pi 4B・XL4015取付ボス外径（基板接触面）: `7.5 mm` (`board_boss_d`、Raspberry Pi基板と干渉しない最大値)
- Raspberry Pi 4B・XL4015取付ボス外径（接地面、割れ対策の末広がり形状）: `9.0 mm` (`board_boss_base_d`)、末広がり部高さ `3.0 mm` (`board_boss_flare_h`)
- Raspberry Pi 4B・XL4015取付ボス内径: `4.95 mm`
- `raspi_board_t = 1.6`
- Raspberry Pi 4B RJ45・USB開口クリアランス: 各辺 `1.0 mm`
- Raspberry Pi 4B 取付ボス（Y方向）: 壁内面から `24 mm`、ピッチ `58 mm`
- XL4015取付ボス: 背面壁内面から `10 mm`、`34 mm x 18 mm`の長方形四隅

Raspberry Pi 4B の基準位置と、RJ-45 / USB-A 開口位置はスクリプト内で定義されています。  
現在の版では `Type-C` 用の開口は含めていません。

## Notes

- 寸法を変更する場合は、ケース外形だけでなくボス位置とコネクタ開口位置の整合も確認してください。
- 3D プリンタで出力する前に、OpenSCAD 上で各 `mode` を確認することを前提としています。
