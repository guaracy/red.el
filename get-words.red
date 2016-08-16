Red []

if-error: function [code [series!] default [any-type!]] [either error? tmp: try code [default] [tmp]]

types: collect [foreach w words-of system/words [if-error [tp: type? get w keep reduce [w tp]] false]]

words: sort collect [foreach [wrd tp] types [if datatype! <> tp [keep wrd]]]

foreach wrd words [prin wrd prin #" "]
