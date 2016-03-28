#!/bin/bash

lessc clean-blog.less ../css/clean-blog.css
lessc --clean-css clean-blog.less ../css/clean-blog.min.css
