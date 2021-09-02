#FROM jupyterhub/jupyterhub
FROM jupyter/scipy-notebook:cf6258237ff9

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
    
RUN pip install --no-cache-dir notebook
RUN pip install --no-cache-dir jupyterhub

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# It must accept command arguments. The Dockerfile will effectively be launched as:
# docker run <image> jupyter notebook <arguments from the mybinder launcher>
# where {}<arguments ...> includes important information automatically set by the binder environment, such as the port and token.

# If your Dockerfile sets or inherits the Docker {}ENTRYPOINT instruction, the program specified as the {}ENTRYPOINT must {}exec the arguments passed by docker. Inherited Dockerfiles may unset the entrypoint with {}ENTRYPOINT [].

#For more information, and a shell wrapper example, please see the Dockerfile best practices: ENTRYPOINT documentation.
