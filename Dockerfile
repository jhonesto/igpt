FROM alpine:latest

MAINTAINER João Honesto www.joaohonesto.com.br

ENV \
	TOKEN="" \
	MODEL="gpt-3.5-turbo-instruct" \
	MAX_TOKENS="1000" \
	TEMPERATURE="1.0" \
	INPUT_COLOR="\033[36m" \
	OUTPUT_COLOR="\033[33m" \
	INFO_COLOR="\033[33m" \
	ERROR_COLOR="\033[31m" \
	FORECOLOR="\033[0m"

RUN apk -U upgrade && apk add --no-cache bash curl python3 && rm -rf /var/cache/apk/*

RUN adduser -D myuser  

COPY --chown=myuser igpt.sh /bin/igpt 

USER myuser

CMD ["/bin/bash"]
