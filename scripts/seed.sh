#!/bin/bash

set -e

rails db:create db:migrate
bin/rails db:seed
