FROM hashicorp/terraform:1.5.0

ADD ./terraform /app
WORKDIR /app

CMD ["sh"]
