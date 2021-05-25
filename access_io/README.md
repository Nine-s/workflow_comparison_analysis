# Access IO

## Goal 

This repository allows you to monitor the io of programs of interest.

## Dependencies 

### systemtap

Using systemtap: 
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/systemtap_beginners_guide/using-systemtap
- https://askubuntu.com/questions/1173904/is-systemtap-broken-on-5-0-0-kernel

Beginner's guide:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/systemtap_beginners_guide/index

This script must be added in this current repository: https://sourceware.org/systemtap/SystemTap_Beginners_Guide/iotimesect.html

### Others

You will need:
- super user priviledge
- Linux
- Python3.x with pandas and plotly

This may not be mandatory. The scripts of this repository have not been tested outside of this context.

## Run

```
sudo bash
./systemtap "command of interest" 
```

Example:

```
sudo bash
./systemtap "python my_script.py" 
```

By default, it will look for the io corresponding to the read or write of the files with extensions specified in `display_io.py` (fasta, fastq, gtf, etc.).

### Options

Instead of using a file extension to filter io, it is also possible:
- to only get io from the pid corresponding to the ran command using `pid`
- to only get io operation by using a word contained in the process name or a filename using `keyword`

#### Example with pid:

```
sudo bash
./systemtap "python my_script.py" pid 
```

It will retrieve all the io operations corresponding to the pid of the command `python my_script.py`

#### Example with keyword:

```
sudo bash
./systemtap "python my_script.py" keyword fq 
```

It will retrieve all of the io operations concerning the filenames that contains the keyword "fq".

## Output

- complete log recorded by systemtap: `log.txt`
- filtered log depending on chosen mode: `io_filtered.csv`
- plotly graph of the io: `plot.html`
