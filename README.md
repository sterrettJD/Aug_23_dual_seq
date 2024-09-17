# Aug 2023 Dual Seq

## Pre-preprocessing

Using tools from [seq-helper-scripts](https://github.com/lozuponelab/seq-helper-scripts)

- `python ../seq-helper-scripts/scripts/reformat_demux/demux_to_ymp_metadata.py -i 230630_A00405_0709_BHCWTWDSX7/230630_A00405_0709_BHCWTWDSX7_L1_Lozupone_demux.csv -o demux_230630.csv -d 230630_A00405_0709_BHCWTWDSX7/ -s 4`
- `python ../seq-helper-scripts/scripts/reformat_demux/demux_to_ymp_metadata.py -i 230623_A00405_0706_BH55KWDSX7/230623_A00405_0706_BH55KWDSX7_L1_Lozupone_demux.csv -o demux_230623.csv -d 230623_A00405_0706_BH55KWDSX7/ -s 4`

- `python utils/concat_split_seq_data.py -m1 demux_230623.csv -m2 demux_230630.csv -mo metadata.csv -o raw_seqs_concat`

## Processing

- Raw data were processed using [HoMi](https://github.com/sterrettJD/HoMi) with the config file `HoMi_config.yaml`, using the script `utils/run_HoMi.sbatch`

## Analysis

- Statistical analyses and visualizations were performed using scripts in the `analysis/` directory.
