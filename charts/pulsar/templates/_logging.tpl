{{/*
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
*/}}

{{/*
Generate log4j2 configuration with both regular and JSON appenders
Pulsar uses PULSAR_LOG_APPENDER env var to select which appender to use
*/}}
{{- define "pulsar.logging.log4j2.yaml" -}}
Configuration:
  status: WARN
  name: pulsar

  Appenders:
    # Console appender for regular text logging
    Console:
      - name: Console
        target: SYSTEM_OUT
        PatternLayout:
          Pattern: "%d{ISO8601_OFFSET_DATE_TIME_HHMM} [%t] %-5level %logger{36} - %msg%n"

      # Console appender for JSON logging
      - name: ConsoleJson
        target: SYSTEM_OUT
        JsonLayout:
          compact: true
          eventEol: true
          complete: false
          stacktraceAsString: true
          KeyValuePair:
            - key: severity
              value: ${event:Level}

  Loggers:
    Root:
      level: info
      AppenderRef:
        - ref: ${sys:pulsar.log.appender:-Console}

    # Reduce verbosity of chatty components
    Logger:
      - name: org.apache.zookeeper
        level: warn
      - name: org.apache.bookkeeper
        level: warn
      - name: io.netty
        level: warn
{{- end -}}
