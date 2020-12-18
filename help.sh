#!/bin/bash

readonly NAME="scala"
readonly LOCALHOST="127.0.0.1"
readonly FULL_PATH="$( cd "$( dirname "$0" )" && pwd )"

helps() {
	case $1 in
		all|*) allhelps ;;
	esac
}

allhelps() {
cat <<EOF
� Usage: ./help.sh COMMAND
[help|usage|build|init|up|down|restart|status|logs|ssh]
[CLI]
  build        Build docker service
  up or start  Run docker-compose as daemon (or up)
  down or stop Terminate all docker containers run by docker-compose (or down)
  restart      Restart docker-compose containers
  status       View docker containers status
  logs         View docker containers logs
  ssh          ssh cli
EOF
}

# Usage
usage() {
	echo "Usage:"
	echo "${0} [help|usage|build|init|up|down|restart|status|logs|ssh]"
}

# run init
run_init() {
	case $1 in
		*|env|dotenv)
			rsync -avz ${FULL_PATH}/env ${FULL_PATH}/.env
		;;
	esac
}

# run build
build() {
	docker-compose build
}

# run start
start() {
	docker-compose up -d
}

# run down
stop() {
	docker-compose down
}

# run restart
restart() {
	docker-compose restart
}

# run status
status() {
	docker-compose ps
}

# run logs
logs() {
	case $1 in
		python) docker-compose logs python;;
		scala) docker-compose logs scala;;
		all|*) docker-compose logs ;;
	esac
}

# run ssh
run_ssh() {
	case $2 in
		*)
			docker-compose exec ${NAME} /bin/bash
		;;
	esac
}

# run cli
run_cli() {
	# echo "Bash version ${BASH_VERSION}..."
	# for i in {1..10}
	# do
	# 	printf "${i}:${!i} "
	# done
	# echo " "

	case $2 in
		help)
cat <<EOF

# cucumber
cli yarn cucumber --tags="@friday" -f json:report/report.json --publish

# robotframework
EOF
		;;
		*)
		  docker-compose exec -T ${NAME} /bin/bash -c \
			  " \
				${2} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
				${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		    ${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		    ${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
				"
		;;
	esac
}

case $1 in
  cli)
	  run_cli \
    ${1} ${2:-help} ${3} ${4} ${5} ${6} ${7} ${8} ${9} ${10} \
		${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} \
		${21} ${22} ${23} ${24} ${25} ${26} ${27} ${28} ${29} ${30} \
		${31} ${32} ${33} ${34} ${35} ${36} ${37} ${38} ${39} ${40}
	;;

	init)
		run_init ${2:-v2}
	;;

	build)
		build
	;;

	start|up)
		start
	;;

	stop|down)
		stop
	;;

	restart|reboot)
		restart
	;;

	status|ps)
		status
	;;

	logs)
		logs ${2:-all}
	;;

	ssh)
		run_ssh \
			${1} ${2}
	;;

	*)
		helps
	;;
esac
