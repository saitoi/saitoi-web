FROM rakudo-star:latest

WORKDIR /app

COPY . /app

# Ensure blog-md and blog-html exist
RUN mkdir -p blog-md blog-html

ENTRYPOINT ["raku", "src/app.raku"]
