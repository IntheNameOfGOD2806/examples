{{/*
Expand the name of the chart.
Always reads from .Chart.Name so renaming the chart just works.
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a fully qualified app name derived from the Helm release name.
  - If fullnameOverride is set → use it directly.
  - If the release name already contains the chart name → use the release name alone.
  - Otherwise → combine release name + chart name.
Truncated to 63 chars (DNS label limit).
*/}}
{{- define "app.fullname" -}}
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

{{/*
Chart label: <chart-name>-<chart-version>
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to every resource.
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels shared by Deployment and Service.
Uses the legacy `app:` label for backward compatibility.
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "app.name" . }}
{{- end }}

{{/*
Resolve the container image string.
Falls back to .Chart.AppVersion when image.tag is empty.
*/}}
{{- define "app.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end }}

{{/*
Name of the ConfigMap that holds runtime config.js.
*/}}
{{- define "app.configmapName" -}}
{{- printf "%s-config" (include "app.fullname" .) }}
{{- end }}
