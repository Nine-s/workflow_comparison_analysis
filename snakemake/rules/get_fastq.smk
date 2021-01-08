import glob

fastqDir = "../data/"

def get_r1(wildcards):
    return glob.glob(fastqDir + wildcards.sample + '_1.fq')

def get_r2(wildcards):
    return glob.glob(fastqDir + wildcards.sample + '_2.fq')
