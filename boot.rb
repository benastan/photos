require 'bundler'
Bundler.require
require 'dotenv'
require 'faraday'
require 'open3'
require 'digest'
require 'pathname'
require 'uri'
require 'fileutils'
require 'sinatra'

Dotenv.load
require 'photos'
