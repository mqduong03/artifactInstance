#!/bin/bash
yum update -y
yum install -y httpd php
systemctl enable httpd