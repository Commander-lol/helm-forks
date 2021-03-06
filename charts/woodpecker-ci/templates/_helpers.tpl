{{/*
Expand the name of the chart.
*/}}
{{- define "woodpecker-ci.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "woodpecker-ci.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "woodpecker-ci.serverdns" -}}
{{ printf "%s.%s.%s:9000" (include "woodpecker-ci.fullname" .) .Release.Namespace .Values.clusterDns }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "woodpecker-ci.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "woodpecker-ci.labels" -}}
helm.sh/chart: {{ include "woodpecker-ci.chart" . }}
{{ include "woodpecker-ci.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "woodpecker-ci.selectorLabels" -}}
app.kubernetes.io/name: {{ include "woodpecker-ci.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "woodpecker-ci.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "woodpecker-ci.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
    Template values 
*/}}

{{- define "woodpecker-ci.serverProtocol" -}}
{{- if .Values.server.tls }}
{{- printf "https" }}
{{- else }}
{{- printf "http" }}
{{- end }}
{{- end }}

{{- define "woodpecker-ci.serverHost" -}}
{{- printf "%s://%s" (include "woodpecker-ci.serverProtocol" .) .Values.server.host }}
{{- end }}