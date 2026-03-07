# Use the Jupyter R notebook as the base image, which includes Jupyter, R, and Python
FROM quay.io/jupyter/r-notebook:latest

# Set the working directory inside the container
WORKDIR /home/jovyan/work

# Switch to root user to install system dependencies
USER root

# Install system libraries required by R packages:
# Also create the renv cache directory and give jovyan ownership of
# the cache and work directories so renv can read/write files
RUN conda install -y -c conda-forge cmake libxml2 r-xml2 && \
    mkdir -p /home/jovyan/.cache/R/renv && \
    chown -R jovyan:users /home/jovyan/.cache && \
    chown -R jovyan:users /home/jovyan/work

# Tell the compiler to look in conda's library path when searching for system libraries
ENV PKG_CONFIG_PATH=/opt/conda/lib/pkgconfig

# Switch back to the default non-root user for security
USER jovyan

# Install renv so we can restore R packages from the lockfile
RUN Rscript -e "install.packages('renv', repos='https://cran.rstudio.com/')"

COPY renv.lock renv.lock

# Restore all R packages from renv.lock, excluding xml2 since it was
RUN Rscript -e "renv::restore(exclude='xml2')"

COPY . .

# Document that the container listens on port 8888 
EXPOSE 8888

# Start Jupyter when the container runs, with no token or password required
CMD ["start-notebook.sh", "--NotebookApp.token=''", "--NotebookApp.password=''"]