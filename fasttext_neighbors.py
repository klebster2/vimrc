import fasttext
import sys
import json

if __name__ == "__main__":
    model = fasttext.load_model(sys.argv[1])
    neighbors = model.get_nearest_neighbors(sys.argv[2], k=100)
    neighbors_output = []
    for i, neighbor in enumerate(neighbors, 1):
        neighbors_output.append(
            {
                "id": i,
                "neighbor": neighbor[1],
                "score": f"{neighbor[0]:.3f}",
            }
        )
    print(json.dumps(neighbors_output, indent=4))
