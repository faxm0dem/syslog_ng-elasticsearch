# Introduction

This repository contains different implementations for sending logs to Elasticsearch
using syslog-ng.

# Usage

Usage depends on the implementation, but usually involves:

* copying the `plugin.conf` and other files to your `scl-root`
  which for instance on my system is `/usr/local/share/include/scl`
* editing the interpreted language files to suit your needs
* copying the relevant configuration from the provided `syslog-ng.conf` file

## Perl

### Requirements

* syslog-ng >= 3.5
* syslog-ng-incubator >= 0.3.3
* [Search::Elasticsearch](http://search.cpan.org/dist/Search-Elasticsearch/lib/Search/Elasticsearch.pm)

### Features

The plugin will allow you to send logs to Elasticsearch using the `perl` module from `syslog-ng-incubator`. It will among other things:

* index your logs
* split keys at the dot `.` in order to create nested structures. For instance if you have a `syslog_ng` macro `pdb.classifier.context_len` it will be indexed in json as `{"pdb": { "classifier" : { "context_len" : 42 } } }`
* add `syslog` *namespace* e.g. common syslog macros like `$SEQNUM` will be indexed as `{"syslog":{"seqnum":1234}}`
* create daily or monthly indices e.g. `syslog_ng-2014.10.03` based on UTC time
* add `pdb` to prefix patterndb name-value pairs

### Configuration

The `elasticsearch` block provided by this implementation exposes the following options:

* `index` The name of the elasticsearch index prefix. The complete index name will be set to `<index>-<timestamping-string>` where `<timestamping-string>` is determined from `timestamping` option (see below). Defaults to `'syslog_ng'`
* `type` The type of the elasticsearch index. Defaults to `'syslog'`
* `scope` The scope of name-value pairs to expose to elasticsearch
* `exclude` Regex to exclude certain keys. Defaults to `'^(__|[A-Z])'` in order to exclude capital syslog-ng macros and double underscore which are being used internally by the perl script.
* `timestamping` String to determine the index date suffix. Any of `'daily'` (yields index name `\`index\`-YYYY.mm.dd` or `'monthly'` (yields index name `\`index\`-YYY.mm`. Defaults to `'daily'`.
* `timestamp_field`Macro to use as `@timestamp` key in elasticsearch. Defaults to `'ISODATE'`
