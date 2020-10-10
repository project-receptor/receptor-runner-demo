This repo demonstrates using Ansible Runner via Receptor.  To use this:

* Have either Podman running as root, or Docker with your user account configured for access to the Docker socket (or run as root).
* Run `test-startup.sh` which will create a three-node Receptor network and install Runner and Ansible.
* Run `test-run.sh` to actually run the demo playbook.
* Run `test-shutdown.sh` to remove the containers and network.
