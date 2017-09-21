#!/bin/bash
#
# Copyright 2014  Gaurav Kumar.   Apache 2.0
# Recipe for callhome/Callhome-Spanish
# Made to integrate KALDI with JOSHUA for end-to-end ASR and SMT

. cmd.sh
. path.sh
# fbankdir=`pwd`/fbank
fbankdir=callhome_fbank
set -e

stage=1

# call the next line with the directory where the Spanish callhome data is
# (the values below are just an example).  This should contain
# subdirectories named as follows:
# DISC1 DIC2

echo "here"

callhome_speech=/disk/scratch/s1444673/zero/corpora/callhome_orig/LDC96S35
callhome_transcripts=/disk/scratch/s1444673/zero/corpora/callhome_orig/LDC96T17

split_callhome=local/splits/split_callhome

echo "data prep"

local/callhome_data_prep.sh $callhome_speech $callhome_transcripts

utils/fix_data_dir.sh data/local/data/callhome_train_all

echo "creating fbanks"

nice steps/make_fbank.sh --nj 30 --cmd "$train_cmd" data/local/data/callhome_train_all exp/make_fbank/callhome_train_all $fbankdir;

utils/fix_data_dir.sh data/local/data/callhome_train_all
utils/validate_data_dir.sh data/local/data/callhome_train_all

echo "copying data"

cp -r data/local/data/callhome_train_all data/callhome_train_all

echo "creating splits"
local/callhome_create_splits.sh $split_callhome

echo "computing cmvn"
# Now compute CMVN stats for the train, dev and test subsets
steps/compute_cmvn_stats.sh data/callhome_dev exp/make_fbank/callhome_dev $fbankdir
steps/compute_cmvn_stats.sh data/callhome_test exp/make_fbank/callhome_test $fbankdir
steps/compute_cmvn_stats.sh data/callhome_train exp/make_fbank/callhome_train $fbankdir


echo "apply cmvn"

nice apply-cmvn --norm-vars=true --utt2spk=ark:data/callhome_train/utt2spk scp:data/callhome_train/cmvn.scp scp:data/callhome_train/feats.scp ark:- | copy-feats ark:- ark,t:callhome_train_fbank.ark
nice apply-cmvn --norm-vars=true --utt2spk=ark:data/callhome_dev/utt2spk scp:data/callhome_dev/cmvn.scp scp:data/callhome_dev/feats.scp ark:- | copy-feats ark:- ark,t:callhome_dev_fbank.ark
nice apply-cmvn --norm-vars=true --utt2spk=ark:data/callhome_test/utt2spk scp:data/callhome_test/cmvn.scp scp:data/callhome_test/feats.scp ark:- | copy-feats ark:- ark,t:callhome_test_fbank.ark

# longjob -28day -c "nice python kaldi_io.py dev.ark dev"
