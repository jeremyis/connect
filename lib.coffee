#!/usr/bin/env coffee

{ spawn } = require 'child_process'

parse = require 'parse-database-url'

commandMySql = (input) ->
  { driver, user, password, host, database } = input
  [
    'mysql',
    '-h', host,
    '-u', user,
    "-p#{password}", # Cannot have a space
    database
  ].join ' '

commandMongo = (driver, input) ->
  { user, password, host, database, port } = input
  host ?= 'localhost'

  if port?
    host = "#{host}:#{port}"
  if database?
    host = "#{host}/#{database}"
  params = [
    driver,
    host
  ]

  if user? and password?
    params = params.concat [ '-u', user, '-p', password ]

  params.join ' '

commandPostgres = (input) ->
  { driver, user, password, host, database, port } = input
  [
    'psql',
    '-h', host,
    '-U', user,
    '-p', port,
    database
  ].join ' '

# TODO: this should get moved to a config
MONGO3_PATH = '~/dev/mongodb-osx-x86_64-3.2.1/bin/mongo'

CONSTRUCTORS =
  'mysql': commandMySql
  'mongodb': commandMongo.bind null, 'mongo'
  'postgres': commandPostgres
  'mongo3': commandMongo.bind null, MONGO3_PATH

constructCommand = (input, driver=null) ->
  #console.log("DRIVER |#{input.driver}|")
  cstr = CONSTRUCTORS[ driver ? input.driver?.trim() ]
  if not cstr?
    throw Error "Unknown driver: #{input.driver}"
  cstr(input)

shspawn = (cmd) ->
  #console.log "shspawn: #{cmd}"
  proc = spawn 'sh', ['-c', cmd], { stdio: 'inherit' }

makeCmd = (input, driver) ->
  params = parse input

  cmd = constructCommand(params, driver)

getAction = (printMode) ->
  return if printMode then console.log.bind(console) else shspawn

module.exports = { getAction, makeCmd }
