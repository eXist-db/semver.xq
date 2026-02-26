import { src, dest, watch, series } from 'gulp'
import { createClient, readOptionsFromEnv } from '@existdb/gulp-exist'
import replace from '@existdb/gulp-replace-tmpl'
import rename from 'gulp-rename'
import zip from 'gulp-zip'
import del from 'delete'

import packageJSON from './package.json' with { type: 'json' }

const { version, license, app } = packageJSON

// .tmpl replacements to include; first value wins
const replacements = [app, { version, license }]

const defaultOptions = { basic_auth: { user: 'admin', pass: '' } }
const connectionOptions = Object.assign(defaultOptions, readOptionsFromEnv())
const existClient = createClient(connectionOptions)

const distFolder = 'dist'
const buildFolder = '.build'
const packageFilename = `semver-xq-${version}.xar`

export function clean (cb) {
  del([distFolder, buildFolder], cb)
}

export function templates () {
  return src('*.tmpl')
    .pipe(replace(replacements, { unprefixed: true }))
    .pipe(rename(path => { path.extname = '' }))
    .pipe(dest(buildFolder))
}

export function copy () {
  return src(['content/**', 'icon.png'], { base: '.', encoding: false })
    .pipe(dest(buildFolder))
}

function xar () {
  return src(`${buildFolder}/**`, { base: buildFolder, encoding: false })
    .pipe(zip(packageFilename))
    .pipe(dest(distFolder))
}

function installXar () {
  return src(packageFilename, { cwd: distFolder, encoding: false })
    .pipe(existClient.install())
}

function uploadTests () {
  return src('test/*.xqm')
    .pipe(existClient.dest({ target: '/db/apps/semver-xq/tests' }))
}

function watchFiles () {
  watch(['content/**', 'icon.png'], series(templates, copy, xar, installXar))
}

const packageLibrary = series(templates, copy, xar)

export const build = series(clean, packageLibrary)
export const install = series(clean, packageLibrary, installXar)

const testInstallAll = series(clean, packageLibrary, installXar, uploadTests)
const testUpload = uploadTests

export {
  testInstallAll as 'test:install-all',
  testUpload as 'test:upload'
}

export default series(clean, packageLibrary, installXar, uploadTests, watchFiles)
