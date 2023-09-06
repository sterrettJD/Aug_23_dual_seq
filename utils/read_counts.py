import pandas as pd

def read_demux_file(fp, skiprow=4):
    return pd.read_csv(fp, skiprows=skiprow)


def remove_fluff_row(df):
    return df.drop(0)


def rename_index(df, colname="Sample"):
    df_copy = df.copy()
    df_copy.index = df_copy[colname]
    return df_copy

def add_reads(df1, df2, colname):
    df1[colname] = df1[colname].apply(lambda x: x.replace(",",""))
    df2[colname] = df2[colname].apply(lambda x: x.replace(",",""))
    return df1[colname].astype(float) + df2[colname].astype(float)


def main():
    p1 = read_demux_file("/Volumes/One Touch/Lozupone/230623_A00405_0706_BH55KWDSX7/230623_A00405_0706_BH55KWDSX7_L4_Lozupone_demux.csv")
    p2 = read_demux_file("/Volumes/One Touch/Lozupone/230630_A00405_0709_BHCWTWDSX7/230630_A00405_0709_BHCWTWDSX7_L1_Lozupone_demux.csv")

    p1 = remove_fluff_row(p1)
    p2 = remove_fluff_row(p2)

    p1 = rename_index(p1)
    p2 = rename_index(p2)

    p2 = p2.reindex_like(p1)
    if sum((p2.index == p1.index))==len(p1.index):
        print("Indexes are matched")

    reads_per_sample = add_reads(p1, p2, "PF Clusters")
    print(reads_per_sample.describe())

if __name__=="__main__":
    main()