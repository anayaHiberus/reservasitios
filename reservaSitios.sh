#!/bin/bash
# Automatic reservation script
# Made by Abel Naya
# adapted from the official linux script

curl -X POST https://reservasitios.demohiberus.com/api/present/autopresent/$USERNAME@hiberus.com/10.50.6.0
