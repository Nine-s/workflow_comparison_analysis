import sys
import argparse
import pandas as pd
import plotly.graph_objects as go

# https://sourceware.org/systemtap/SystemTap_Beginners_Guide/iotimesect.html


def merge_access_iotime(df):
    # put iotime in the same row as access
    for index in range(1, len(df)):
        if((df['type'].iloc[index] == "iotime") and (df['file'].iloc[index] == df['file'].iloc[index - 1])):
            df['iotime'].iloc[index - 1] = df['read'].iloc[index]
            df['iotime'].iloc[index] = -12

    df = df.loc[df['iotime'] != -12]
    return df


def create_figs_list_no_gaps(df):
    ts_r = []
    ts_w = []
    reads = []
    writes = []
    text_r = []
    text_w = []

    for index in range(len(df)):
        if(int(df["read"].iloc[index]) != 0):
            reads.append(df["read"].iloc[index])
            ts_r.append(df["timestamp"].iloc[index])
            description = f"bytes: {df['read'].iloc[index]}\niotime: {df['iotime'].iloc[index]}\nfile: {df['file'].iloc[index]}\nprocess_name: {df['process_name'].iloc[index]}"
            text_r.append(description)
        elif(int(df["write"].iloc[index]) != 0):
            writes.append(df["write"].iloc[index])
            ts_w.append(df["timestamp"].iloc[index])
            description = f"bytes: {df['write'].iloc[index]}\niotime: {df['iotime'].iloc[index]}\nfile: {df['file'].iloc[index]}\nprocess_name: {df['process_name'].iloc[index]}"
            text_w.append(description)
    return ts_r, ts_w, reads, writes, text_r, text_w


def create_plotly_plot(io_type, ts_r, ts_w, reads, writes, text_r, text_w):
    color1 = '#9467bd'
    color2 = '#F08B00'

    fig = go.Figure()

    fig.add_trace(
        go.Scatter(
            x=ts_r,
            y=[int(x) for x in reads],
            name='reads',
            text=text_r,
            mode='lines+markers',
            line=dict(
                color=color1
            )
        )
    )

    fig.add_trace(
        go.Scatter(
            x=ts_w,
            y=[int(x) for x in writes],
            name='writes',
            text=text_w,
            mode='lines+markers',
            line=dict(
                color=color2
            )
        )
    )

    fig.update_layout(title_text=io_type, xaxis_title="timestamp",
                      yaxis_title="bytes")
    fig.write_html("plot.html")


def main(argv):

    # MODIFY IF NECESSARY
    extension_biofiles = [".fq", ".fastq", ".fa", ".fasta", ".bam",
                          ".sam", ".gtf", ".ht2", "fastqc.zip", ".fastp.json", "summary.log"]

    # get arguments

    parser = argparse.ArgumentParser(
        description='Provides io of a process of interest (log and graph). By default, looks for a defined list of biological file extensions in the filenames of the log file. You can use the PID of a process of interest or a keyword')
    parser.add_argument("-l", "--log_file",
                        help="Log file that will be treated.")
    parser.add_argument("-pid", "--process_id", type=int,
                        help="pid: looks for all the processes in the log corresponding to a PID", nargs='?')
    parser.add_argument(
        "-k", "--keyword", help="word: looks for a key word in the process name or filename in the log", nargs='?')

    args = parser.parse_args()
    print(args)

    log = args.log_file

    if (log is None):
        print("A log file must be provided, use -h for help")
        quit()

    elif (args.process_id is None and args.keyword is not None):
        mode = "key"
        keyword = args.keyword
    elif (args.process_id is not None and args.keyword is None):
        mode = "pid"
        pid = args.process_id
    elif (args.process_id is None and args.keyword is None):
        mode = "ext"

    # file to dataframe

    data = pd.read_csv(log, delim_whitespace=True, header=None, names=[
        "timestamp", "process_id", "process_name", "type", "file", "info_read", "read", "info_write", "write", "iotime"])
    df = pd.DataFrame(data)

    # drop unecessary columns

    df = df.drop('info_read', 1)
    df = df.drop('info_write', 1)

    # keep the rows of interest

    if(mode == "pid"):
        df = df.loc[df['process_id'] == int(pid)]

    elif(mode == "keyword"):
        df1 = df.loc[df['process_name'].str.contains(keyword)]
        df2 = df.loc[df['file'].str.contains(keyword)]
        df = pd.concat([df1, df2], axis=0, copy=False)
        df = df.sort_values(by=['timestamp'])

    elif(mode == "ext"):
        df0 = df.loc[df['file'].str[-len(extension_biofiles[0]):]
                     == extension_biofiles[0]]
        for i in range(1, len(extension_biofiles)):
            df1 = df.loc[df['file'].str[-len(extension_biofiles[i]):]
                         == extension_biofiles[i]]
            df0 = pd.concat([df0, df1], axis=0, copy=False)
        df = df0
        df = df.sort_values(by=['timestamp'])

    # merge access and associated iotime lines

    df = merge_access_iotime(df)
    df = df.loc[~df['iotime'].isna()]
    df["iotime"] = df["iotime"].astype('int')

    print(df)  # optional
    df.to_csv("io_filtered.csv")
    print("--> io_filtered.csv is created")

    # create fig with plotly

    ts_r, ts_w, reads, writes, text_r, text_w = create_figs_list_no_gaps(df)
    create_plotly_plot(df["process_name"].iloc[0], ts_r,
                       ts_w, reads, writes, text_r, text_w)
    print("--> plot.html is created")


main(sys.argv[1:])
