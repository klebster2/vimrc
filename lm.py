import kenlm
import sys
import json
import os
import requests
# StringIO
from io import StringIO
import urllib

if __name__ == "__main__":
    # if not os.path.exists("en-70k-0.2-pruned.lm"):
    #     url = "https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/US%20English/en-70k-0.2-pruned.lm.gz/download"
    #     r = requests.get(url, allow_redirects=True) 
    #     #with gzip.decompress(resp.read())
    #     with open('file.txt', 'wb') as f_out:
    #         shutil.copyfileobj(gzipfile, f_out)

    #     with open(, 'wb') as f:
    #         f.write(r.content)
    stopwords = {
        "ourselves", "hers", "between", "yourself", "but",
        "again", "there", "about", "once", "during",
        "out", "very", "having", "with", "they",
        "own", "an", "be", "some", "for",
        "do", "its", "yours", "such", "into",
        "of", "most", "itself", "other", "off",
        "is", "s", "am", "or", "who",
        "as", "from", "him", "each", "the",
        "themselves", "until", "below", "are", "we",
        "these", "your", "his", "through", "don",
        "nor", "me", "were", "her", "more",
        "himself", "this", "down", "should", "our",
        "their", "while", "above", "both", "up",
        "to", "ours", "had", "she", "all",
        "no", "when", "at", "any", "before",
        "them", "same", "and", "been", "have",
        "in", "will", "on", "does", "yourselves",
        "then", "that", "because", "what", "over",
        "why", "so", "can", "did", "not",
        "now", "under", "he", "you", "herself",
        "has", "just", "where", "too", "only",
        "myself", "which", "those", "i", "after",
        "few", "whom", "t", "being", "if",
        "theirs", "my", "against", "a", "by",
        "doing", "it", "how", "further", "was",
        "here", "than"
    }

    remove_stopwords = True

    entries = []
    model_name = sys.argv[2]  # "en-70k-0.2-pruned.lm"
    model = kenlm.Model(model_name)
    for line in sys.stdin.readlines():
        for entry in json.loads(line):
            if remove_stopwords and entry["word"] in stopwords:
                continue

            string = f"{entry['word']} {sys.argv[1]}"
            per=model.score(string, bos = True, eos = False)
            entry.update({"perplexity":per})
            entry.update({"perplexity_str": f"{per:.2f}"})
            entry.update({"model": model_name})
            entries.append(entry)

    entries = sorted(entries, key=lambda x: x["perplexity"], reverse=True)
    print(json.dumps(entries))
