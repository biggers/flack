# (was) Makefile for Flask course: "build_sass_app_udemy"
# ... also see: Section 6, Lecture 25 (coding challenge)


# -------------------------------- Dev/Test, Docker targets

WAIT_FOR = 5
DC = docker-compose
DCF = docker-compose -f docker/docker-compose-dev.yml
# alias dcf='docker-compose -f $PWD/docker/docker-compose-dev.yml'

## ---- DEV targets -- Docker and docker-compose

SVC = --force flack
OPTS = # --force-rm --pull

run: run_local

build_dev: requirements.txt
	${DCF} build ${OPTS} ${SVC}

up:
	${DCF} up -d
	sleep ${WAIT_FOR}; ${DCF} logs

stop:
	${DCF} stop

down:
	${DCF} down --volumes --remove-orphans

ps: status
status:
	${DCF} ps

LOGSF = # --follow
logs:
	${DCF} logs ${LOGSF}

# -------------------------------- Dev/Test "shell" targets

run_local:
	env FLASK_DEBUG=1  FLASK_APP='flack' \
	FLASK_ENV='development' \
	python -m flask run --reload --host 127.0.0.1 --port 5000

CMD=shell
run_cmd:
	env FLASK_DEBUG=1  FLASK_APP='flack' \
	FLASK_ENV='development' \
	python -m flask ${CMD}

run_manage:
	env FLASK_DEBUG=1  FLASK_APP='flack' \
	FLASK_ENV='development' \
	python -m pdb manage.py ${CMD}

run_migrate_ch05:
	. venv/bin/activate; \
	export FLASK_DEBUG=1; \
	export FLASK_APP='flasky.app'; \
	manage.py db init; \
	manage.py db revision --autogenerate -m '1st revision'; \
	manage.py db upgrade

# NOTE: may have to do:
# sqlite> .tables
# alembic_version  role  user           
# sqlite> DROP TABLE alembic_version;

run_xxx:
	make clean
	/bin/rm -rf migrations

lint:
	flake8 --exclude=env .

test:
	py.test tests

## -------------------------------- Cleaning, cleaning...

clean: clean_pycache

clean_pycache:
	find . | grep -E "(__pycache__|\.pyc|\.pyo$$)" | xargs rm -rf

clean_rmi:
	docker rmi $$(docker images -f "dangling=true" -q)

SVC = flack
clean_docker: stop
	${DCF} rm -v ${SVC}
