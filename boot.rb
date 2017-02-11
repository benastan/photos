require 'bundler'
Bundler.require
require 'dotenv'

require 'open3'
require 'json'
require 'digest'
require 'pathname'
require 'uri'
require 'fileutils'

require 'faraday'
require 'sinatra'

Dotenv.load
require 'photos'
