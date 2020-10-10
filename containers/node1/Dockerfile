FROM receptor:latest
RUN dnf -y install git gcc python-devel && dnf clean all
RUN pip install git+https://github.com/ansible/ansible-runner
