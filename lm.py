import kenlm
import sys
import json
import requests
from pathlib import Path
import gzip
import shutil
import io

if __name__ == "__main__":
    if not Path(Path( __file__),"en-70k-0.2-pruned.lm").exists():
        url = "https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/US%20English/en-70k-0.2-pruned.lm.gz/download"

        r = requests.get(url, allow_redirects=True) 
        gzipfile = gzip.decompress(r.content)

        with open("en-70k-0.2-pruned.lm", 'wb') as f_out:
            with io.BytesIO(gzipfile) as f_in:
                shutil.copyfileobj(f_in, f_out)

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
