import pynvim

import fasttext
import sys
import json
import os

from collections.abc import Iterable

from typing import Iterable, Tuple

import re

# https://github.com/jacobsimpson/nvim-example-python-plugin
def fsa(word):
    """
    Acceptor Based on common FastText garbage words
    """
    if re.match(".*[a-z]\.[A-Z].*", word): # reject inter-word fullstop
        return False
    elif re.match(".*[A-Z0-9].*", word): # Reject capital letters and numbers
        return False
    elif re.match(r".*([a-z])\1{2,}", word):
        return False
    else:
        return True


@pynvim.plugin
class FastTextWordNeighborsPlugin(object):

    def __init__(self, nvim):
        self.nvim = nvim
        self.neighbors = 6

    @pynvim.command('LoadFastTextModel', sync=False)
    def _load_model(self):
        self.model = fasttext.load_model("/home/kleber/.fasttext_fastapi/cc.en.300.bin")

    def _smoketest(self):
        """
        returns none but also ensures speedier loading
        """
        self.model.get_nearest_neighbors("smoke-test", 1)


    @pynvim.command('FastTextWordNeighbors', sync=False)
    def get_word_neighbors(self):
        dropstrange=True
        # get data on current line
        col_n = self.nvim.eval("col('.')")
        line = self.nvim.eval("getline('.')")
        globally_nearest_left = 0
        globally_nearest_right  = len(line)

        for m in re.finditer("^|\s+|$", line):
            # save spans between current column and boundaries
            if col_n - m.span()[1] < globally_nearest_left and (col_n - m.span()[1]) > 0:
                globally_nearest_left = m.span()[1]
            if m.span()[0] - col_n < globally_nearest_right and (m.span()[0] - col_n) > 0:
                globally_nearest_right = m.span()[0]

        word = self.nvim.eval("getline('.')")[globally_nearest_left:globally_nearest_right]

        neighbors = self.model.get_nearest_neighbors(
            word,
            k=self.neighbors,
        )

        neighbors_output = []

        # re-add current word for context in case
        neighbors_output.append(
            {
                "icase": 1,
                "word": word,
                "menu": "1",
            }
        )

        for i, neighbor in enumerate(neighbors, 1):
            if fsa(word=neighbor[1]) and dropstrange:
                neighbors_output.append(
                    {
                        "icase": 1,
                        "word": neighbor[1],
                        "menu": f"{neighbor[0]:.3f}",
                    }
                )
            elif not dropstrange:
                neighbors_output.append(
                    {
                        "icase": 1,
                        "word": neighbor[1],
                        "menu": f"{neighbor[0]:.3f}",
                    }
                )
            else:
                continue

        self.nvim.funcs.complete(globally_nearest_right, neighbors_output)
