curl -X POST -H "Content-Type: application/JSON" \
    --data '["Containers are more or less interesting"]' \
    http://127.0.0.1:5000/predict

curl -X POST -H "Content-Type: application/JSON" \
    --data '["MLOps is critical for robustness"]' \
    http://127.0.0.1:5000/predict
