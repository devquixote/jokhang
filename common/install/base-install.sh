#!/bin/bash

#######################
# Reusable log function
#######################
function log() {
  msg=${1}

  echo "$(date): ${msg}"
}


#######################
# Block to override in
# children for custom
# install steps
#######################
{% block install %}
echo "You should override the install block"
{% endblock %}
