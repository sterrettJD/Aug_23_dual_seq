import argparse
import pandas as pd
import subprocess
from os import path

def get_args():
    """
    handles arg parsing for this script

    returns the parsed args
    """
    parser = argparse.ArgumentParser(
        prog="Concatenate split sequencing data",
        description="Anschutz Genomics core will split deep sequencing into multiple files \
                (e.g., 50M reads in one file, 50M reads in another). \
                This program combines those into one fastq."
    )

    parser.add_argument("-m1", "--metadata_1",
                        required=True)
    parser.add_argument("-m2", "--metadata_2",
                        required=True)
    parser.add_argument("-mo", "--metadata_output",
                        required=True)
    parser.add_argument("-o", "--output_directory",
                        required=True)
     
    return parser.parse_args()


def combine_metadata(metadata_1, metadata_2):
    return pd.concat([metadata_1, 
               metadata_2.rename(columns=dict(zip(metadata_2.columns, 
                                                  [col+"_2" for col in metadata_2.columns])))
               ], axis=1)


def submit_concat_job(file1, file2, output):
    command = ["sbatch", "utils/concat_files.sbatch", 
                "-1", file1,
                "-2", file2,
                "-o", output]
    print(f"Running command: \n{' '.join(command)}")
    subprocess.run(command)
    


def main():
    args = get_args()

    metadata_1 = pd.read_csv(args.metadata_1)
    metadata_1 = metadata_1.set_index("Sample")
    metadata_2 = pd.read_csv(args.metadata_2)
    metadata_2 = metadata_2.set_index("Sample")

    comb_metadata = combine_metadata(metadata_1, metadata_2)

    for i, sample in enumerate(comb_metadata.index):
        fwd_1 = comb_metadata.loc[sample, "ForwardReads"]
        fwd_2 = comb_metadata.loc[sample, "ForwardReads_2"]
        print(fwd_2)
        submit_concat_job(fwd_1, fwd_2, 
                          path.join(args.output_directory, f"{sample}.R1.fq.gz"))

        rev_1 = comb_metadata.loc[sample, "ReverseReads"]
        rev_2 = comb_metadata.loc[sample, "ReverseReads_2"]
        submit_concat_job(rev_1, rev_2, 
                          path.join(args.output_directory, f"{sample}.R2.fq.gz"))

        comb_metadata.loc[sample, "ForwardReads"] = path.join(args.output_directory, 
                                                         f"{sample}.R1.fq.gz")
        comb_metadata.loc[sample, "ReverseReads"] = path.join(args.output_directory, 
                                                         f"{sample}.R2.fq.gz")
    comb_metadata.drop(["ForwardReads_2", "ReverseReads_2"], axis=1)
    comb_metadata.to_csv(args.metadata_output)


    

if __name__=="__main__":
    main()
