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
- Raspberry Pi 4B・XL4015取付ボス外径: `9.0 mm` (`board_boss_d`)
- Raspberry Pi 4B・XL4015取付ボス内径: `4.95 mm`
- `raspi_board_t = 1.6`
- Raspberry Pi 4B RJ45・USB開口クリアランス: 各辺 `1.0 mm`
- Raspberry Pi 4B 取付ボス（Y方向）: 壁内面から `24 mm`、ピッチ `58 mm`
- XL4015取付ボス: 背面壁内面から `16 mm`（Raspberry Pi基板後端と干渉しない範囲で最大化）、`34 mm x 18 mm`の長方形四隅
- 上フタの貫通穴: `3.0 mm` (`xl_center_hole_d`)、X座標は左右排熱スリット列の中間、Y座標はXL4015中心位置
- 上フタのエンボス文字: `"WF-Server"`（180度回転）、高さ `1.0 mm` (`emboss_h`)、文字サイズ `5 mm` (`emboss_size`)、後方の空きスペース中央（y=117.5mm）に配置

Raspberry Pi 4B の基準位置と、RJ-45 / USB-A 開口位置はスクリプト内で定義されています。  
現在の版では `Type-C` 用の開口は含めていません。

## Notes

- 寸法を変更する場合は、ケース外形だけでなくボス位置とコネクタ開口位置の整合も確認してください。
- 3D プリンタで出力する前に、OpenSCAD 上で各 `mode` を確認することを前提としています。

## 運用メモ（WF-Server 本体の電源・終了・保全）

このケースは `Raspberry Pi 4B` + headless `wfserver`（IC-7300 / IC-9700 リモートシステム）を
収める前提です。ソフト側の詳細な導入・運用手順は
[`IC7300Controller`](https://github.com/kazushinjo/IC7300Controller) を参照してください。
ここではケース設計と関わる範囲の運用ポイントをまとめます。

### 無線機の電源 OFF/ON（CI-V 経由）

- リモートの wfview クライアントの電源ボタンで、CI-V コマンドにより無線機本体を入切します。
- 電源 ON は、無線機がオフでも **Pi の USB 給電が本体に残っていること**が前提です。
  Pi は systemd で常時起動のため、**Pi の電源が入っていれば USB 給電は継続**します。
- ケース設計上の注意: USB ケーブルが常時挿さる前提なので、USB-A / RJ-45 開口部の
  クリアランス（各辺 `1.0 mm`）とケーブルの取り回しに余裕を持たせてください。

### プログラム（サービス）の終了

- GUI の `File → Exit` ではなく **systemd 操作**で管理します。
  - 停止: `sudo systemctl stop wfserver`
  - 再起動: `sudo systemctl restart wfserver`（設定変更の反映時）

### 設定の保全

- wfview の「Save Settings」ではなく、**`wfserver --setup` が作る `~/.config/wfserver/ic7300.ini`（/ `ic9700.ini`）を正**とします。
- IC-7300 本体側の CI-V 設定は無線機自身が保持するもので、`wfserver` の設定とは別物です。

### リモート電源 ON が成立する条件

1. **Pi 本体が起動し、USB 給電が生きている**（最重要。Pi が落ちていると原理的に不可）。
2. **`wfserver` サービスが active**（`systemctl status wfserver` で確認）。
3. **`WF_RADIO` が接続したい機種と一致**（ic7300 / ic9700）。
4. **本体の CI-V 設定**が正しい（USB Port: `Unlink from [REMOTE]`、Echo Back: `ON`、
   Address: IC-7300 `94h` / IC-9700 `A2h`、Baud Rate 一致）。
5. **Tailscale が両側で up**、接続ポート・ユーザー名・パスワードがクライアントと一致。

> 発熱源（Pi 4B・XL4015）を密閉するため、上フタの排熱スリットと `xl_center_hole_d` の
> 貫通穴は塞がないこと。常時稼働の連続運用では放熱が電源系の安定にも影響します。
