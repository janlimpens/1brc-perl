# 1brc-perl
1 Billion Record Challenge in Perl

Original challenge for Java: <https://github.com/gunnarmorling/1brc>

To get the full input file, clone that repo according the instructions and run the commands to generate it. It's not included in this repo.

I have included the first 1M rows in the zipped file "test.zip".


### Some numbers

My machine specs:

Model name: Intel(R) Core(TM) i7-5557U CPU @ 3.10GHz


Output of `free -h`:

```
               total        used        free      shared  buff/cache   available
Mem:            15Gi       1,4Gi       195Mi       472Mi        13Gi        13Gi
Swap:          2,0Gi       1,9Gi       148Mi

```

Java reference implementation in the original repo runs in around 3m

Using `cat` to write the file to /dev/null takes ~18s.
