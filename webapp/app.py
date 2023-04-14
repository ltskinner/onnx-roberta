import numpy as np
import onnxruntime
import torch
from flask import Flask, jsonify, request
from transformers import RobertaTokenizer

app = Flask(__name__)
tokenizer = RobertaTokenizer.from_pretrained("roberta-base")
session = onnxruntime.InferenceSession("roberta-sequence-classification-9.onnx")


@app.route("/", methods=["GET"])
def index():
    return jsonify({"status": "running"})


@app.route("/predict", methods=["POST"])
def predict():
    input_ids = torch.tensor(
        tokenizer.encode(request.json[0], add_special_tokens=True)
    ).unsqueeze(0)

    if input_ids.requires_grad:
        numpy_func = input_ids.detach().cpu().numpy()
    else:
        numpy_func = input_ids.cpu().numpy()

    key = session.get_inputs()[0].name
    value = numpy_func
    inputs = {key: value}
    out = session.run(None, inputs)

    result = np.argmax(out)
    return jsonify({"poositive": bool(result)})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
