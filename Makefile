#!/bin/bash

#!make
include .env
export $(shell sed 's/=.*//' .env)

schedule:
	gcloud beta scheduler jobs create pubsub notify-billing-to-slack-${tag} \
	--project savvy-kit-260206 \
	--schedule "00 12 * * *" \
	--topic topic-billing \
	--message-body="execute" \
	--time-zone "Asia/Seoul" \
	 --description "This job invokes cloud function via cloud pubsub and send GCP billing to slack"

deploy:
	gcloud functions deploy notifyBilling-${tag} \
	--project savvy-kit-260206 \
	--entry-point NotifyBilling \
	--trigger-resource topic-billing \
 	--trigger-event google.pubsub.topic.publish \
 	--runtime go111 \
 	--set-env-vars TABLE_NAME=${TABLE_NAME}\
 	--set-env-vars SLACK_API_TOKEN=${SLACK_API_TOKEN} \
 	--set-env-vars SLACK_CHANNEL=${SLACK_CHANNEL}
