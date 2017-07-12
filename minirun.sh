#!/bin/bash
#
# Copyright 2014  Gaurav Kumar.   Apache 2.0
# Recipe for Fisher/Callhome-Spanish
# Made to integrate KALDI with JOSHUA for end-to-end ASR and SMT

. cmd.sh
. path.sh
# mfccdir=`pwd`/mfcc
mfccdir=mfcc
set -e

stage=1

# call the next line with the directory where the Spanish Fisher data is
# (the values below are just an example).  This should contain
# subdirectories named as follows:
# DISC1 DIC2

echo "here"

sfisher_speech=/afs/inf.ed.ac.uk/group/project/lowres/work/corpora/fisher_orig/spanish/LDC2010S01
sfisher_transcripts=/afs/inf.ed.ac.uk/group/project/lowres/work/corpora/fisher_orig/spanish/LDC2010T04

split=local/splits/split_fisher


echo "data prep"

local/fsp_data_prep.sh $sfisher_speech $sfisher_transcripts

# utils/fix_data_dir.sh data/local/data/train_all

# echo "creating mfccs"

# nice steps/make_mfcc.sh --nj 30 --cmd "$train_cmd" data/local/data/train_all exp/make_mfcc/train_all $mfccdir;

# utils/fix_data_dir.sh data/local/data/train_all
# utils/validate_data_dir.sh data/local/data/train_all

# echo "copying data"

# cp -r data/local/data/train_all data/train_all

# echo "creating splits"
# local/create_splits.sh $split

# echo "computing cmvn"
# # Now compute CMVN stats for the train, dev and test subsets
# steps/compute_cmvn_stats.sh data/train exp/make_mfcc/train $mfccdir
# steps/compute_cmvn_stats.sh data/dev exp/make_mfcc/dev $mfccdir
# steps/compute_cmvn_stats.sh data/test exp/make_mfcc/test $mfccdir
# steps/compute_cmvn_stats.sh data/dev2 exp/make_mfcc/dev2 $mfccdir


# nice apply-cmvn --norm-vars=true --utt2spk=ark:data/train/utt2spk scp:data/train/cmvn.scp scp:data/train/feats.scp ark:- | add-deltas ark:- ark:- | copy-feats ark:- ark,t:train.ark
# nice apply-cmvn --norm-vars=true --utt2spk=ark:data/dev/utt2spk scp:data/dev/cmvn.scp scp:data/dev/feats.scp ark:- | add-deltas ark:- ark:- | copy-feats ark:- ark,t:dev.ark
# nice apply-cmvn --norm-vars=true --utt2spk=ark:data/dev2/utt2spk scp:data/dev2/cmvn.scp scp:data/dev2/feats.scp ark:- | add-deltas ark:- ark:- | copy-feats ark:- ark,t:dev2.ark
# nice apply-cmvn --norm-vars=true --utt2spk=ark:data/test/utt2spk scp:data/test/cmvn.scp scp:data/test/feats.scp ark:- | add-deltas ark:- ark:- | copy-feats ark:- ark,t:test.ark

# longjob -28day -c "nice python kaldi_io.py dev.ark dev"