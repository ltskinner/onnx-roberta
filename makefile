setup:
	conda create --name onnx-38 python=3.8

source:
	conda activate onnx-38

install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

install-test:
	pip install -r requirements-test.txt

lint-force:
	isort .
	black .
	flake8 . --ignore=E501
	pylint --disable=R,C,pointless-string-statement ./webapp

lint-check:
	isort . --check-only
	black --check .
	flake8 . --ignore=E501
	#pylint --disable=R,C,pointless-string-statement ./webapp

run-app:
	python webapp/app.py

docker-build:
	docker build -t ltskinner/onnx-roberta:latest .

docker-run:
	# on everything holy
	# 80:8000 grabs an app running on 8000 forwards to container 80
	docker run -d --name oxra -p 5000:5000 ltskinner/onnx-roberta

docker-poll:
	docker ps --format "table {{.Image}}\t{{.Status}}\t{{.Names}}\t{{.Ports}}"

docker-stop:
	docker stop oxra

docker-push:
	docker push ltskinner/onnx-roberta:latest
