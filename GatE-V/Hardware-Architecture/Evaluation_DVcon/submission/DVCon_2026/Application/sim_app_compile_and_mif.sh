echo "Checking for Docker.."
./.docker_scripts/install_and_load_docker.sh
docker run -it --rm -v $(pwd)/../../DVCon_2026:/mnt/dvcon dvcon_2 sh -c  "cd /mnt/dvcon && cd Application && ./.docker_scripts/sim_app_compile_and_mif.sh"
