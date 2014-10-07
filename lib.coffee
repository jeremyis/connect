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

commandMongo = (input) ->
  { driver, user, password, host, database, port } = input
  host ?= 'localhost'

  if port?
    host = "#{host}:#{port}"
  if database?
    host = "#{host}/#{database}"
  params = [
    'mongo',
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

CONSTRUCTORS =
  'mysql': commandMySql
  'mongodb': commandMongo
  'postgres': commandPostgres

constructCommand = (input) ->
  #console.log("DRIVER |#{input.driver}|")
  cstr = CONSTRUCTORS[ input.driver?.trim() ]
  console.log input
  if not cstr?
    throw Error "Unknown driver: #{input.driver}"
  cstr(input)

shspawn = (cmd) ->
  #console.log "shspawn: #{cmd}"
  proc = spawn 'sh', ['-c', cmd], { stdio: 'inherit' }

makeCmd = (input) ->
  params = parse input

  cmd = constructCommand(params)

getAction = (printMode) ->
  return if printMode then console.log.bind(console) else shspawn

module.exports = { getAction, makeCmd }
