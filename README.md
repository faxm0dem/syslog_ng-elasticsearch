# Deprecation

The release of 3.7.1 brings the native java plugin to life.
This means the instructions in this article are obsolete.
They can however be used as examples on how to use the perl and python drivers.

The section on java was updated accordingly

# Introduction

This repository contains different implementations for sending logs to Elasticsearch
using syslog-ng.

# Usage

Usage depends on the implementation, but usually involves:

* copying the `plugin.conf` and other files to your `scl-root`
  which for instance on my system is `/usr/local/share/include/scl`
* editing the interpreted language files to suit your needs
* copying the relevant configuration from the provided `syslog-ng.conf` file

## Java

### Requirements

* syslog-ng >= 3.7.1
* syslog-ng-java and jre >= 1.7
* elasticsearch >= 1.4.0

### Features

The plugin will allow you to send logs to Elasticsearch using the `java` module from `syslog-ng-3.7.1` and the native java client from the elasticsearch distribution.

### Configuration

* Install elasticsearch *e.g.* using RPM
* Copy configuration files `java/plugin.conf` and `java/syslog-ng.conf` to relevant destinations
* Modify elasticsearch, plugin and lucene jar paths according to your environment
* configure ldconfig or set `LD_LIBRARY_PATH` to the path of `libjvm.so`

## Perl

### Requirements

* syslog-ng >= 3.5
* syslog-ng-incubator >= 0.3.3
* [Search::Elasticsearch](http://search.cpan.org/dist/Search-Elasticsearch/lib/Search/Elasticsearch.pm)

### Features

The plugin will allow you to send logs to Elasticsearch using the `perl` module from `syslog-ng-incubator`. It will among other things:

* index your logs
* create daily or monthly indices e.g. `syslog_ng-2014.10.03` based on UTC time
* remove the leading dot from special name-value pairs

### Configuration

The `elasticsearch` block provided by this implementation exposes the following options:

* `index` The name of the elasticsearch index prefix. The complete index name will be set to `<index>-<timestamping-string>` where `<timestamping-string>` is determined from `timestamping` option (see below). Defaults to `'syslog_ng'`
* `type` The type of the elasticsearch index. Defaults to `'syslog'`
* `template` The template to use for the json data. Defaults to `"$(format-json -s all-nv-pairs -x __* -p @timestamp=$ISODATE --rekey .* --shift 1)")`
* `timestamping` String to determine the index date suffix. Any of `'daily'` (yields index name `\`index\`-YYYY.mm.dd` or `'monthly'` (yields index name `\`index\`-YYY.mm`. Defaults to `'daily'`.

# Appendix

## Apache logs

Using the python integration introduced by 3.7.1, we can also elegantly have apache send json logs.
This could be done by crafting the JSON manually in apache.conf, but this approach has obvious issues
with escaping special characters like `\` and `"` in the payload.

The apache directory contains an example on how to achieve this

## GeoIP

In the geoip directory you will find an example on how to index geo points with Elasticsearch.

