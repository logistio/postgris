ARG POSTGIS_VERSION=3.0.0
ARG POSTGRES_MAJOR=11

FROM bitnami/postgresql:${POSTGRES_MAJOR}
ARG POSTGIS_VERSION
USER root


RUN install_packages wget gcc make build-essential libxml2-dev libgeos-dev libproj-dev libgdal-dev \
    && cd /tmp \
    && wget "http://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz" \
    && export C_INCLUDE_PATH=/opt/bitnami/postgresql/include/:/opt/bitnami/common/include/ \
    && export LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && export LD_LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && tar zxf postgis-${POSTGIS_VERSION}.tar.gz && cd postgis-${POSTGIS_VERSION} \
    && ./configure --with-pgconfig=/opt/bitnami/postgresql/bin/pg_config \
    && make \
    && make install

USER 1001